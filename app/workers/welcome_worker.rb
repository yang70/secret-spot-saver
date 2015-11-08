class WelcomeWorker
  include Sidekiq::Worker

  def perform(userid)
    user = User.find(userid)
    UserMailer.new_welcome_email(user).deliver_later
  end
end
