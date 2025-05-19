class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.decimal :fats
      t.decimal :carbs
      t.decimal :proteins
      t.decimal :fibers

      t.timestamps
    end
  end
end
