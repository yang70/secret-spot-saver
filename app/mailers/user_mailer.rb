class UserMailer < ApplicationMailer
  default to: Proc.new { [@user.email, 'matt@matthewgyang.com'] },
    :from => 'matt@matthewgyang.com'

  def new_welcome_email(user)
    @user = user
    mail(subject: "Welcome!")
  end
end
