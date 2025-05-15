class Meal < ApplicationRecord
  belongs_to :user
  has_many :dishes, dependent: :destroy

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[user dishes]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name user_id created_at updated_at]
  end
end
