class Dish < ApplicationRecord
  belongs_to :meal

  has_many :dish_ingredients, dependent: :destroy
  has_many :ingredients, through: :dish_ingredients
  has_many :dish_recipes, dependent: :destroy
  has_many :recipes, through: :dish_recipes

  accepts_nested_attributes_for :dish_ingredients, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :meal_id, presence: true

  def kcal
    dish_ingredients.joins(:ingredient).sum("ingredients.energy_kcal * dish_ingredients.quantity / 100.0").round(1)
  end

  def fats
    dish_ingredients.joins(:ingredient).sum("ingredients.fats * dish_ingredients.quantity / 100.0").round(1)
  end

  def proteins
    dish_ingredients.joins(:ingredient).sum("ingredients.proteins * dish_ingredients.quantity / 100.0").round(1)
  end

  def carbs
    dish_ingredients.joins(:ingredient).sum("ingredients.carbs * dish_ingredients.quantity / 100.0").round(1)
  end

  def fibers
    dish_ingredients.joins(:ingredient).sum("ingredients.fibers * dish_ingredients.quantity / 100.0").round(1)
  end

  def ratio
    cp = carbs + proteins
    cp > 0 ? (fats / cp).round(2) : 0
  end

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[meal dish_ingredients ingredients dish_recipes recipes]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name meal_id created_at updated_at]
  end
end
