require "test_helper"

class DishIngredientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dish_ingredients_index_url
    assert_response :success
  end

  test "should get show" do
    get dish_ingredients_show_url
    assert_response :success
  end

  test "should get create" do
    get dish_ingredients_create_url
    assert_response :success
  end

  test "should get update" do
    get dish_ingredients_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dish_ingredients_destroy_url
    assert_response :success
  end
end
