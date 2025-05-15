class DishIngredient < ApplicationRecord
  belongs_to :dish
  belongs_to :ingredient

  validates :quantity, numericality: { greater_than: 0 }

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish ingredient]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id dish_id ingredient_id quantity created_at updated_at]
  end
end
