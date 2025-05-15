class Ingredient < ApplicationRecord
  has_many :dish_ingredients, dependent: :destroy
  has_many :dishes, through: :dish_ingredients

  validates :name, presence: true
  validates :carbs, :proteins, :fats, :fibers, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish_ingredients dishes]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name carbs proteins fats fibers created_at updated_at]
  end
end
