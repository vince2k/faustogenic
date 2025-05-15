class CreateDishRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :dish_recipes do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
