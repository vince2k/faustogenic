class UpdateIngredientsForCiqual < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :ciqual_code, :string
    add_column :ingredients, :source, :string
    add_column :ingredients, :energy_kcal, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :ingredients, :sugars, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :ingredients, :food_group_id, :bigint
    add_index :ingredients, :ciqual_code, unique: true
    add_foreign_key :ingredients, :food_groups, optional: true
  end
end
