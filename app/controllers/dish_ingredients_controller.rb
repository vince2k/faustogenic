class DishIngredientsController < ApplicationController
  before_action :authenticate_user!

  def create
    @dish_ingredient = DishIngredient.new(dish_ingredient_params)

    if @dish_ingredient.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Ingrédient ajouté." }
      end
    else
      render turbo_stream: turbo_stream.replace("dish_#{@dish_ingredient.dish_id}_form", partial: "dish_ingredients/form", locals: { dish: @dish_ingredient.dish })
    end
  end

  private

  def dish_ingredient_params
    params.require(:dish_ingredient).permit(:dish_id, :ingredient_id, :quantity)
  end
end
