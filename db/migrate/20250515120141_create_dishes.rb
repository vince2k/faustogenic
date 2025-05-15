class CreateDishes < ActiveRecord::Migration[7.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.references :meal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
