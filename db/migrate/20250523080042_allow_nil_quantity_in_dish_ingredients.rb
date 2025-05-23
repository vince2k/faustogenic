class AllowNilQuantityInDishIngredients < ActiveRecord::Migration[7.0]
  def change
    change_column_null :dish_ingredients, :quantity, true
  end
end
