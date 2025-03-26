require "test_helper"

class FridgesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get fridges_show_url
    assert_response :success
  end

  test "should get update" do
    get fridges_update_url
    assert_response :success
  end
end
