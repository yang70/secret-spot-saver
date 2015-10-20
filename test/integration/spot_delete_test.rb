require "test_helper"

class SpotsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    sign_in("ruby")
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
