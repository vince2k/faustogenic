class Day < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user_id, message: "Vous avez déjà enregistré une  journée pour cette date." }

  def macros
    all_dish_ingredients = meals.flat_map { |meal| meal.dishes.flat_map(&:dish_ingredients) }
    
    total = {
      kcal:     0.0,
      fats:     0.0,
      proteins: 0.0,
      carbs:    0.0,
      fibers:   0.0,
    }

    all_dish_ingredients.each do |di|
      total[:kcal]     += di.kcal
      total[:fats]     += di.fats
      total[:proteins] += di.proteins
      total[:carbs]    += di.carbs
      total[:fibers]   += di.fibers
    end

    total[:ratio] = (total[:carbs] + total[:proteins] > 0) ? total[:fats] / (total[:carbs] + total[:proteins]) : 0.0

    total
  end
  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[user meals]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id date created_at updated_at]
  end
end
