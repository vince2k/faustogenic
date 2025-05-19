# app/models/food_group.rb
class FoodGroup < ApplicationRecord
  belongs_to :parent, class_name: 'FoodGroup', optional: true
  has_many :children, class_name: 'FoodGroup', foreign_key: :parent_id, dependent: :destroy
  has_many :ingredients, dependent: :restrict_with_error

  validates :name, presence: true
  validates :ciqual_group_code, uniqueness: true, allow_nil: true
end
