class UserMailer < ApplicationMailer
  default :from => 'matt@matthewgyang.com'

  def new_welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome!")
    mail(to: 'matt@matthewgyang.com', subject: 'New Secret Spot User')
  end
end
