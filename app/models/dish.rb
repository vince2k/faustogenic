class Dish < ApplicationRecord
  belongs_to :meal

  has_many :dish_ingredients, dependent: :destroy
  has_many :ingredients, through: :dish_ingredients
  has_many :dish_recipes, dependent: :destroy
  has_many :recipes, through: :dish_recipes

  validates :name, presence: true
end
