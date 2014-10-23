class UserCoupon
  # Methods
  def self.coupon_for_amount(amount)
    case amount
    when 997 then 'off2'
    when 2000 then 'off3'
    end
  end
end
