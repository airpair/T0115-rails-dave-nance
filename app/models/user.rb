class User < ActiveRecord::Base
  # Extensions
  include Stripe::Callbacks
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Callbacks
  before_create :create_stripe_customer
  after_customer_updated! do |customer, event|
    user = User.where(stripe_customer_id: customer.id).first

    if customer.account_balance < 1000
      Notifications.low_balance(user).deliver
    end
  end

  # Methods
  def do_deposit_transaction(type, stripe_token)
    amount = Transaction.amount_for_type(type)
    coupon = UserCoupon.coupon_for_amount(amount)

    card = save_credit_card(stripe_token)
    if deposited = deposit(amount, card)
      subscribe if type == 'subscription'
      create_coupon(coupon) if coupon

      deposited
    end
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def deposit(amount, card)
    customer = stripe_customer

    Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: customer.id,
      card: card.id,
      description: "Charge for #{email}"
    )

    customer.account_balance += amount
    customer.save
  rescue => e
    false
  end

  private

  def subscribe
    stripe_customer.subscriptions.create(plan: 'monthly')
  end

  def create_coupon(coupon)
    customer = stripe_customer
    already_has_off3_coupon = customer.discount && customer.discount.any? { |type, co| type == :coupon && co.id == 'off3' }

    return true if coupon == 'off3' && already_has_off3_coupon

    customer.coupon = coupon
    customer.save
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(email: email, account_balance: 0)
    self.stripe_customer_id = customer.id
  end

  def save_credit_card(card_token)
    stripe_customer.cards.create(card: card_token)
  end
end
