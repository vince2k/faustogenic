class Ingredient < ApplicationRecord
  has_many :dish_ingredients, dependent: :destroy
  has_many :dishes, through: :dish_ingredients

  validates :name, presence: true
  validates :carbs, :proteins, :fats, :fibers, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
