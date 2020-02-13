require 'test_helper'

class AdvancedControllerTest < ActionDispatch::IntegrationTest
  test "should return advanced search page" do
    get '/advanced'
    assert_response :success
  end

  # Should Fail
  test "should not return a unicorn page" do
    assert_raises ActionController::RoutingError do
      get '/unicorn'
    end
  end
end
