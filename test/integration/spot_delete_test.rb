require "test_helper"

class SpotsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    sign_in("matt")
  end

  test 'deletes a spot' do
    delete "/spots/#{spots(:spot_1).id}"
    message = json(response.body)
    assert_equal 200, response.status
    assert_equal message[:message], "Spot deleted"
  end
end
