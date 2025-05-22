class Day < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user_id, message: "Vous avez déjà enregistré une  journée pour cette date." }

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[user meals]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id date created_at updated_at]
  end
end
