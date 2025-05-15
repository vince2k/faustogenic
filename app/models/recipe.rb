class Recipe < ApplicationRecord
  has_many :dish_recipes, dependent: :destroy
  has_many :dishes, through: :dish_recipes
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :name, presence: true

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish_recipes dishes recipe_ingredients ingredients]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name description created_at updated_at]
  end
end
