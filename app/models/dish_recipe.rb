class DishRecipe < ApplicationRecord
  belongs_to :dish
  belongs_to :recipe
end
