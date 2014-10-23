class Notifications < ActionMailer::Base
  default from: 'from@example.com'

  def low_balance(user)
    @message = 'Your balance is lower than $10'

    mail to: user.email
  end

  def inactive_user(user)
    @message = "You've been inactive for a month"

    mail to: user.email
  end
end
