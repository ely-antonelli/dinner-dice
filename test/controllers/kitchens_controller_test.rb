require "test_helper"

class KitchensControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get kitchens_show_url
    assert_response :success
  end
end
