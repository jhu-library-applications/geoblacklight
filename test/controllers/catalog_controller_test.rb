require 'test_helper'

class CatalogControllerTest < ActionDispatch::IntegrationTest
  test "should return centroids in json results" do
    get '/catalog', params: { format: 'json' }
    assert_response :success
    assert_equal 'application/json; charset=utf-8', response.content_type

    json = JSON.parse(response.body)
    refute_empty json["centroids"]
  end
end
