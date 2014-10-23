Stripe.plan :monthly do |plan|
  plan.name = 'Monthly subscription'
  plan.amount = 997
  plan.currency = 'usd'
  plan.interval = 'month'
end
