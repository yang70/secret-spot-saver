require "test_helper"
require "database_cleaner"

class SpotPatchTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Capybara.current_driver = Capybara.javascript_driver
    sign_in("ruby")
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'sign in, successful update' do
    patch "/spots/#{spots(:spot_4).id}",
      { spot: { name: "New name" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 200, response.status
    assert_equal 'New name', spots(:spot_4).reload.name
  end

  test 'sign in, unsuccessful update (improper format)' do
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end

  test 'not signed in, unsuccessful update' do
    sign_out
    patch "/spots/#{spots(:spot_2).id}",
      { spot: { name: "New name" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 401, response.status
    error = json(response.body)[:error]
    assert_equal error, "You need to sign in or sign up before continuing."
  end
end
