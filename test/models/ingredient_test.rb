require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "should create manual ingredient" do
    ingredient = Ingredient.create!(
      name: "Chocolat noir",
      source: "Manual",
      energy_kcal: 600,
      proteins: 7,
      fats: 40,
      carbs: 45,
      sugars: 30,
      fibers: 8
    )
    assert ingredient.valid?
    assert_equal "Manual", ingredient.source
  end

  test "should import ciqual data" do
    food_group = FoodGroup.create!(name: "Fruits", ciqual_group_code: "01")
    ingredient = Ingredient.create!(
      name: "Pomme",
      ciqual_code: "13008",
      source: "Ciqual",
      energy_kcal: 52,
      proteins: 0.3,
      fats: 0.2,
      carbs: 11.6,
      sugars: 11,
      fibers: 2.4,
      food_group: food_group
    )
    assert ingredient.valid?
    assert_equal food_group, ingredient.food_group
  end
end
