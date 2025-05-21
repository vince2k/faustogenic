class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :meals, dependent: :destroy
  has_many :days, dependent: :destroy

  has_one_attached :avatar

  def display_name
    nickname.presence || email
  end

  # Ransack autorisation
  def self.ransackable_attributes(_auth_object = nil)
    ["id", "email","nickname", "first_name", "last_name", "created_at", "updated_at"]
  end
end
