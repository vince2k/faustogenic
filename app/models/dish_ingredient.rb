class DishIngredient < ApplicationRecord
  belongs_to :dish
  belongs_to :ingredient

  validates :quantity, numericality: { greater_than: 0 }
end
