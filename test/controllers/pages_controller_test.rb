require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should return a about page" do
    get '/about'
    assert_response :success
  end

  test "should return a contribute page" do
    get '/contact'
    assert_response :success
  end

  test "should return a help page" do
    get '/help'
    assert_response :success
  end

  # Should Fail
  test "should not return a unicorn page" do
    assert_raises ActionController::RoutingError do
      get '/unicorn'
    end
  end
end
