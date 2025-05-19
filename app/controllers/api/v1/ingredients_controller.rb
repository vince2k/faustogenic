class Api::V1::IngredientsController < Api::V1::BaseController
  before_action :set_ingredient, only: [:show, :update, :destroy]

  def index
    @ingredients = Ingredient.first(10)
    render json: @ingredients, include: :food_group
  end

  def show
    render json: @ingredient, include: :food_group
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      render json: @ingredient, status: :created, include: :food_group
    else
      render json: @ingredient.errors, status: :unprocessable_entity
    end
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :ciqual_code, :source, :energy_kcal, :proteins, :fats, :carbs, :sugars, :fibers, :food_group_id)
  end
end
