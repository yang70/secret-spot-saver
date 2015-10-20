require 'test_helper'

class UserLogoutTest < ActionDispatch::IntegrationTest
  def setup
    sign_in("ruby")
  end

  test 'logged in user can log out' do
    delete '/users/sign_out'
    confirm_sign_out = response.status
    assert_equal confirm_sign_out, 302
  end
end
