require "test_helper"
require "database_cleaner"

class SpotDeleteTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Capybara.current_driver = Capybara.javascript_driver
    sign_in("ruby")
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'sign in, delete a spot' do
    delete "/spots/#{spots(:spot_1).id}"
    message = json(response.body)
    assert_equal 200, response.status
    assert_equal message[:message], "Spot deleted"
  end

  test 'not signed in, cannot delete and redirects' do
    sign_out
    delete "/spots/#{spots(:spot_1).id}"
    assert_equal 302, response.status
  end
end
