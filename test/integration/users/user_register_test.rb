require 'test_helper'

class UserRegisterTest < ActionDispatch::IntegrationTest

  test 'new user can register and sign in' do
    post '/users',
      { user: { email: "new@example.com",
                password: "password",
                password_confirmation: "password" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_up = json(response.body)
    assert_equal confirm_sign_up[:email], "new@example.com"
    sign_in("new")
  end

  test 'invalid email will not register' do
    post '/users',
      { user: { email: "new@exampl",
                password: "password",
                password_confirmation: "password" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_up = json(response.body)
    assert_equal confirm_sign_up[:errors][:email][0], "is invalid"
  end

  test 'password empty will not register' do
    post '/users',
      { user: { email: "new@example.com",
                password: "",
                password_confirmation: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_up = json(response.body)
    assert_equal confirm_sign_up[:errors][:password][0], "can't be blank"
  end

  test 'password under limit will not register' do
    post '/users',
      { user: { email: "new@example.com",
                password: "passwor",
                password_confirmation: "passwor" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_up = json(response.body)
    assert_equal confirm_sign_up[:errors][:password][0], "is too short (minimum is 8 characters)"
  end

  test 'password mismatch will not register' do
    post '/users',
      { user: { email: "new@example.com",
                password: "passwordlong",
                password_confirmation: "password" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    confirm_sign_up = json(response.body)
    assert_equal confirm_sign_up[:errors][:password_confirmation][0], "doesn't match Password"
  end
end
