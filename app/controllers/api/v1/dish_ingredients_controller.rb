# app/controllers/dish_ingredients_controller.rb
class DishIngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dish_ingredient, only: [:update]

  def create
    @dish_ingredient = DishIngredient.new(dish_ingredient_params)
    @dish = @dish_ingredient.dish
    @meal = @dish.meal
    @day = @meal.day

    if @dish_ingredient.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      # gestion d'erreur
    end
  end

  # def update
  #   @dish_ingredient = DishIngredient.find(params[:id])
  #   Rails.logger.debug "Mise à jour de DishIngredient ##{@dish_ingredient.id} avec params: #{dish_ingredient_params.inspect}"

  #   if @dish_ingredient.update(dish_ingredient_params)
  #     redirect_to day_path(@dish_ingredient.dish.meal.day), notice: "Quantité mise à jour."
  #   else
  #     Rails.logger.debug "Erreur lors de la mise à jour: #{@dish_ingredient.errors.full_messages}"
  #     render turbo_stream: turbo_stream.replace(
  #       "dish_ingredient_#{@dish_ingredient.id}_quantity",
  #       partial: "dish_ingredients/edit",
  #       locals: { dish_ingredient: @dish_ingredient }
  #     )
  #   end
  # end

  def update
    @dish_ingredient = DishIngredient.find(params[:id])
    Rails.logger.debug "Mise à jour de DishIngredient ##{@dish_ingredient.id} avec params: #{dish_ingredient_params.inspect}"

    if @dish_ingredient.update(dish_ingredient_params)
      redirect_to day_path(@dish_ingredient.dish.meal.day), notice: "Quantité mise à jour."
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

  def set_dish_ingredient
    @dish_ingredient = DishIngredient.find(params[:id])
  end

  def dish_ingredient_params
    params.require(:dish_ingredient).permit(:dish_id, :ingredient_id, :quantity)
  end
end
