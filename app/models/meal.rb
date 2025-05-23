class Meal < ApplicationRecord
  belongs_to :user
  belongs_to :day
  has_many :dishes, dependent: :destroy

  def macros
    kcal = fats = proteins = carbs = fibers = 0.0

    dishes.each do |dish|
      dish.dish_ingredients.each do |di|
        kcal     += di.kcal
        fats     += di.fats
        proteins += di.proteins
        carbs    += di.carbs
        fibers   += di.fibers
      end
    end

    cp = carbs + proteins
    ratio = cp > 0 ? fats / cp : 0

    {
      kcal: kcal,
      fats: fats,
      proteins: proteins,
      carbs: carbs,
      fibers: fibers,
      ratio: ratio
    }
  end

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[user dishes]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name user_id created_at updated_at]
  end
end
