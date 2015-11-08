class Notify < ApplicationMailer
  default :from => 'matt@matthewgyang.com'

  def new_user_email(user)
    @user = user
    mail(to: 'matt@matthewgyang.com', subject: "New user")
  end
end
