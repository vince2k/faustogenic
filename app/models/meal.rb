class Meal < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy
end
