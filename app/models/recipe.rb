class Recipe < ApplicationRecord
  has_many :dish_recipes, dependent: :destroy
  has_many :dishes, through: :dish_recipes
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :name, presence: true
end
