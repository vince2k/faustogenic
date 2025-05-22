class AddDayToMeals < ActiveRecord::Migration[7.1]
  def change
    add_reference :meals, :day, null: false, foreign_key: true
  end
end
