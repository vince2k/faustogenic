require "test_helper"

class DishRecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dish_recipes_index_url
    assert_response :success
  end

  test "should get show" do
    get dish_recipes_show_url
    assert_response :success
  end

  test "should get create" do
    get dish_recipes_create_url
    assert_response :success
  end

  test "should get update" do
    get dish_recipes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dish_recipes_destroy_url
    assert_response :success
  end
end
