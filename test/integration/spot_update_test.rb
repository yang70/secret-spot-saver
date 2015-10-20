require "test_helper"

class SpotsPatchTest < ActionDispatch::IntegrationTest
  def setup
    sign_in("ruby")
  end

  test 'sign in, successful update' do
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "New name" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 200, response.status
    assert_equal 'New name', spots(:spot_1).reload.name
  end

  test 'sign in, unsuccessful update (improper format)' do
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end

  test 'not signed in, unsuccessful update' do
    sign_out
    patch "/spots/#{spots(:spot_1).id}",
      { spot: { name: "New name" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 401, response.status
    error = json(response.body)[:error]
    assert_equal error, "You need to sign in or sign up before continuing."
  end
end
