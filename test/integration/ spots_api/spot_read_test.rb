require "test_helper"
require "database_cleaner"

class SpotGetTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Capybara.current_driver = Capybara.javascript_driver
    sign_in("ruby")
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'sign in, get index returns all spots for user' do
    get '/spots', {}, { Accept: Mime::JSON }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    spots = json(response.body)[:spots]
    assert_equal "Notes for one.", spots.detect { |spot| spot[:name] == "Spot One" }[:notes]
    assert_equal "Notes for two.", spots.detect { |spot| spot[:name] == "Spot Two"}[:notes]
  end

  test 'sign in, returns spot by id' do
    get "/spots/#{spots(:spot_1).id}"
    assert_equal 200, response.status
    spot = json(response.body)[:spot]
    assert_equal "Notes for one.", spot[:notes]
  end

  test 'not signed in, get index returns error' do
    sign_out
    get '/spots', {}, { Accept: Mime::JSON }
    assert_equal 401, response.status
    error = json(response.body)[:error]
    assert_equal error, "You need to sign in or sign up before continuing."
  end

  test 'not signed in, return spoty by id returns error' do
    sign_out
    get '/spots', {}, { Accept: Mime::JSON }
    assert_equal 401, response.status
    error = json(response.body)[:error]
    assert_equal error, "You need to sign in or sign up before continuing."
  end

  test 'sign in other user, gets the correct spots' do
    sign_out
    sign_in("aaron")
    get '/spots', {}, { Accept: Mime::JSON }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    spots = json(response.body)[:spots]
    assert_equal spots.length, 2
    assert_equal "Notes for three.", spots.detect { |spot| spot[:name] == "Spot Three" }[:notes]
  end
end
