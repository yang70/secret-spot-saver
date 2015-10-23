require "test_helper"
require "database_cleaner"

class SpotCreateTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Capybara.current_driver = Capybara.javascript_driver
    sign_in("ruby")
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'sign in, creates a new spot' do
    post '/spots',
      { spot:
        { user_id: users(:ruby).id,
          name: 'My Spot',
          lat: 45,
          lon: -73,
          water_type: 'small stream',
          technique: 'dry fly',
          notes: 'Great spot! multiple strikes on size 12 orange stimulator when the sun hit the water around 11am.  Slippery rocks, bring traction shoes next time' }
      }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    spot = json(response.body)[:spot]
    assert_equal spot_url(spot[:id]), response.location
  end

  test 'sign in, does not create without a lattitude or longitude' do
    post '/spots',
      { spot: { name: "new, spot",
                user_id: users(:ruby).id } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end

  test 'not signed in, cannot create' do
    sign_out
    post '/spots',
      { spot:
        { name: 'My Spot',
          lat: 45,
          lon: -73,
          water_type: 'small stream',
          technique: 'dry fly',
          notes: 'Great spot! multiple strikes on size 12 orange stimulator when the sun hit the water around 11am.  Slippery rocks, bring traction shoes next time' }
      }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 401, response.status
    error = json(response.body)[:error]
    assert_equal error, "You need to sign in or sign up before continuing."
  end
end
