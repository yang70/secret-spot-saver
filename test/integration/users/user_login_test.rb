require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  test 'existing user can sign in' do
    post '/users/sign_in',
    { user: { email: "ruby@example.com", password: "password" } }.to_json,
    { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_in = json(response.body)
    assert_equal confirm_sign_in[:email], "ruby@example.com"
  end

  test 'nonexisting user cannot sign in' do
    post '/users/sign_in',
    { user: { email: "fake@example.com", password: "password" } }.to_json,
    { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_in = json(response.body)
    assert_equal confirm_sign_in[:error], "Invalid email or password."
  end
end
