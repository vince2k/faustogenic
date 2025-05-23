module DaysHelper
  def macros_for(day)
    fats = carbs = proteins = kcal = 0.0

    day.meals.includes(dishes: { dish_ingredients: :ingredient }).each do |meal|
      meal.dishes.each do |dish|
        dish.dish_ingredients.each do |di|
          i = di.ingredient
          q = di.quantity.to_f
          fats     += i.fats.to_f         * q / 100.0
          carbs    += i.carbs.to_f        * q / 100.0
          proteins += i.proteins.to_f     * q / 100.0
          kcal     += i.energy_kcal.to_f  * q / 100.0
        end
      end
    end

    ratio = (carbs + proteins) > 0 ? fats / (carbs + proteins) : 0

    {
      kcal: kcal.round,
      fats: fats.round(1),
      carbs: carbs.round(1),
      proteins: proteins.round(1),
      ratio: ratio.round(2)
    }
  end
end
