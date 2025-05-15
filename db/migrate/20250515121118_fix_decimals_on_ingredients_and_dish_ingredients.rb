class FixDecimalsOnIngredientsAndDishIngredients < ActiveRecord::Migration[7.1]
  def change
    change_column :dish_ingredients, :quantity, :decimal, precision: 10, scale: 2, null: false
    change_column :ingredients, :carbs, :decimal, precision: 10, scale: 2, null: false, default: 0
    change_column :ingredients, :proteins, :decimal, precision: 10, scale: 2, null: false, default: 0
    change_column :ingredients, :fats, :decimal, precision: 10, scale: 2, null: false, default: 0
    change_column :ingredients, :fibers, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
# This migration modifies the `quantity` column in the `dish_ingredients` table and the `carbs`, `proteins`, `fats`, and `fibers` columns in the `ingredients` table to have a precision of 10 and a scale of 2. It also sets the default value for the `carbs`, `proteins`, `fats`, and `fibers` columns to 0 and ensures that they cannot be null.
