class CreateDishIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :dish_ingredients do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :quantity, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
