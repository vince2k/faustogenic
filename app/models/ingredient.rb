# app/models/ingredient.rb
class Ingredient < ApplicationRecord
  belongs_to :food_group, optional: true
  has_many :dish_ingredients, dependent: :destroy
  has_many :dishes, through: :dish_ingredients
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
  validates :carbs, :proteins, :fats, :fibers, :energy_kcal, :sugars, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ciqual_code, uniqueness: true, allow_nil: true
  validates :source, inclusion: { in: ['Manual', 'Ciqual', 'OpenFoodFacts'], allow_nil: true }

  # Callbacks pour calculer le keto_ratio automatiquement
  before_create :set_ratio, :set_energy_kcal
  before_update :update_ratio_if_needed, :update_energy_kcal_if_needed

  # Constante pour le ratio maximum (quand proteins + carbs = 0 mais fats > 0)
  MAX_RATIO = 999.99

  # Calculer le ratio cétogène
  def calculate_ratio
    return 0.0 if fats.nil? || proteins.nil? || carbs.nil?

    denominator = proteins + carbs
    if denominator.zero? && fats.zero?
      return 0.0
    elsif denominator.zero? && fats.positive?
      return MAX_RATIO
    end

    (fats / denominator).round(2)
  end

  # Calculer l'apport calorique : (Lipides × 9) + (Protéines × 4) + (Glucides × 4)
  def calculate_energy_kcal
    return 0.0 if fats.nil? || proteins.nil? || carbs.nil?

    (fats * 9 + proteins * 4 + carbs * 4).round(2)
  end

  # Formater les valeurs pour éviter la notation scientifique dans la console
  %w[energy_kcal proteins fats carbs sugars fibers].each do |attr|
    define_method(attr) do
      value = super()
      value&.round(2)
    end
  end

  def inspect
    attributes = {
      id: id,
      name: name,
      energy_kcal: energy_kcal ? format("%.2f", energy_kcal) : nil,
      proteins: proteins ? format("%.2f", proteins) : nil,
      fats: fats ? format("%.2f", fats) : nil,
      carbs: carbs ? format("%.2f", carbs) : nil,
      sugars: sugars ? format("%.2f", sugars) : nil,
      fibers: fibers ? format("%.2f", fibers) : nil,
      created_at: created_at,
      updated_at: updated_at,
      ciqual_code: ciqual_code,
      source: source,
      food_group_id: food_group_id
    }
    "#<Ingredient #{attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(', ')}>"
  end

  # Ransack associations
  def self.ransackable_associations(_auth_object = nil)
    %w[dish_ingredients dishes recipe_ingredients recipes food_group]
  end

  # Ransack attributes
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name carbs proteins fats fibers ciqual_code source energy_kcal sugars ratio food_group_id created_at updated_at]
  end

private

  # Callback avant création : calculer le ratio
  def set_ratio
    self.ratio = calculate_ratio
  end

  # Callback avant création : calculer l'apport calorique si non défini
  def set_energy_kcal
    # Ne pas écraser energy_kcal si déjà défini (ex. : données Ciqual)
    self.energy_kcal = calculate_energy_kcal if energy_kcal.nil? || energy_kcal.zero?
  end

  # Callback avant mise à jour : recalculer le ratio si nécessaire
  def update_ratio_if_needed
    if fats_changed? || proteins_changed? || carbs_changed?
      self.ratio = calculate_keto_ratio
    end
  end

  # Callback avant mise à jour : recalculer l'apport calorique si nécessaire
  def update_energy_kcal_if_needed
    if fats_changed? || proteins_changed? || carbs_changed?
      # Ne recalculer que si energy_kcal n'est pas défini ou si la source est "Manual"
      if energy_kcal.nil? || energy_kcal.zero? || source == "Manual"
        self.energy_kcal = calculate_energy_kcal
      end
    end
  end
end
