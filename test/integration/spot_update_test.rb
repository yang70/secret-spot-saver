require "test_helper"

class SpotsPatchTest < ActionDispatch::IntegrationTest
  def setup
    sign_in("matt")
  end

  test 'successful update' do
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "New name" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 200, response.status
    assert_equal 'New name', spots(:spot_1).reload.name
  end

  test 'unsuccessful update' do
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
