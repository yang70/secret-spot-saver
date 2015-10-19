Rails.env = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  fixtures :all

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
end

def sign_in(name)
  post '/users/sign_in',
  { user: { email: "#{name}@example.com", password: "password" } }.to_json,
  { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
  confirm_sign_in = json(response.body)
  assert_equal confirm_sign_in[:email], "matt@example.com"
end
