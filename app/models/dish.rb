class Dish < ApplicationRecord
  belongs_to :meal

  has_many :dish_ingredients, dependent: :destroy
  has_many :ingredients, through: :dish_ingredients
  has_many :dish_recipes, dependent: :destroy
  has_many :recipes, through: :dish_recipes

  accepts_nested_attributes_for :dish_ingredients, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :meal_id, presence: true

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[meal dish_ingredients ingredients dish_recipes recipes]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name meal_id created_at updated_at]
  end
end
