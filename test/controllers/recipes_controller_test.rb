require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recipes_index_url
    assert_response :success
  end

  test "should get show" do
    get recipes_show_url
    assert_response :success
  end

  test "should get random" do
    get recipes_random_url
    assert_response :success
  end
end
