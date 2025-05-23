class DishRecipe < ApplicationRecord
  belongs_to :dish
  belongs_to :recipe

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish recipe]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id dish_id recipe_id created_at updated_at]
  end
end
