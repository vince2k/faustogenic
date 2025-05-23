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

  def edit
    @dish_ingredient = DishIngredient.find(params[:id])
  end

  def update
    @dish_ingredient = DishIngredient.find(params[:id])

    Rails.logger.debug "Mise à jour de DishIngredient ##{@dish_ingredient.id} avec params: #{dish_ingredient_params.inspect}"

    if @dish_ingredient.update(dish_ingredient_params)
      # Recharger les associations pour garantir des données à jour
      @dish_ingredient.dish.reload
      @dish_ingredient.dish.meal.reload
      @dish_ingredient.dish.meal.day.reload

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Quantité mise à jour." }
      end
    else
      Rails.logger.debug "Erreur lors de la mise à jour: #{@dish_ingredient.errors.full_messages}"
      render turbo_stream: turbo_stream.replace(
        "dish_ingredient_#{@dish_ingredient.id}_quantity",
        partial: "dish_ingredients/edit",
        locals: { dish_ingredient: @dish_ingredient }
      )
    end
  end


  private

  def dish_ingredient_params
    params.require(:dish_ingredient).permit(:dish_id, :ingredient_id, :quantity)
  end
end
