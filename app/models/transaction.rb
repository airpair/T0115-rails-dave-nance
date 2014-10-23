class Transaction
  # Methods
  def self.amount_for_type(type)
    case type
    when 'subscription' then 997
    when 'deposit' then 2000
    when 'purchase' then 700
    end
  end
end
