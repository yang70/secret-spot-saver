class NotifyWorker
  include Sidekiq::Worker

  def perform(userid)
    user = User.find(userid)
    NotifyMailer.new_user_email(user).deliver_later
  end
end
