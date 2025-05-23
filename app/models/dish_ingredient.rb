class DishIngredient < ApplicationRecord
  belongs_to :dish
  belongs_to :ingredient

  def kcal
    return 0 unless quantity && ingredient&.energy_kcal
    ingredient.energy_kcal * quantity / 100.0
  end

  def fats
    return 0 unless quantity && ingredient&.fats
    ingredient.fats * quantity / 100.0
  end

  def proteins
    return 0 unless quantity && ingredient&.proteins
    ingredient.proteins * quantity / 100.0
  end

  def carbs
    return 0 unless quantity && ingredient&.carbs
    ingredient.carbs * quantity / 100.0
  end

  def fibers
    return 0 unless quantity && ingredient&.fibers
    ingredient.fibers * quantity / 100.0
  end

  def ratio
    cp = carbs + proteins
    cp > 0 ? fats / cp : 0
  end

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish ingredient]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id dish_id ingredient_id quantity created_at updated_at]
  end
end
