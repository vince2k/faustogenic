class CreateFoodGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :food_groups do |t|
      t.string :name
      t.string :ciqual_group_code
      t.bigint :parent_id
      t.timestamps
    end
    add_index :food_groups, :ciqual_group_code, unique: true
    add_foreign_key :food_groups, :food_groups, column: :parent_id, optional: true
  end
end
