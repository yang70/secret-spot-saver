require "test_helper"

class SpotsDeleteTest < ActionDispatch::IntegrationTest

  test 'deletes a spot' do
    delete "/spot/#{spots(:spot_1).id}"
    assert_equal 204, response.status
  end
end
