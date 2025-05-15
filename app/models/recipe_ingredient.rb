class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[recipe ingredient]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id recipe_id ingredient_id quantity created_at updated_at]
  end
end
