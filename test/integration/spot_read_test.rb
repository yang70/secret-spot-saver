require "test_helper"

class SpotsGetTest < ActionDispatch::IntegrationTest

  test 'returns all spots' do
    get '/spots', {}, { Accept: Mime::JSON }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    spots = json(response.body)[:spots]
    assert_equal "Notes for one.", spots.detect { |spot| spot[:name] == "Spot One" }[:notes]
  end

  test 'returns spot by id' do
    spot = spot.find_by(name: "Spot One")
    get "/spots/#{spot.id}"
    assert_equal 200, response.status
    spot = json(response.body)
    assert_equal "Notes for one.", spot[:notes]
  end
end
