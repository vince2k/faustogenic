class Api::V1::IngredientsController < Api::V1::BaseController
  before_action :set_ingredient, only: [:show]

  def index
    @ingredients = Ingredient.sample(100)
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

  def autocomplete
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    escaped = ActiveRecord::Base.connection.quote(query)

    # 1. Résultats pertinents avec priorité début + similarité
    ingredients = Ingredient
      .where("unaccent(name) ILIKE unaccent(?) OR similarity(unaccent(name), unaccent(?)) > 0.2", "%#{query}%", query)
      .order(Arel.sql(<<~SQL.squish))
        CASE
          WHEN unaccent(name) ILIKE unaccent(#{escaped} || '%') THEN 0
          ELSE 1
        END,
        similarity(unaccent(name), unaccent(#{escaped})) DESC
      SQL
      .limit(10)

    # 2. Fallback par mots si très peu de résultats
    if ingredients.size < 3
      words = query.upcase.split
      fallback = Ingredient.where(
        words.map { "unaccent(UPPER(name)) LIKE unaccent(?)" }.join(" AND "),
        *words.map { |w| "%#{w}%" }
      ).limit(10)
      ingredients = (ingredients + fallback).uniq.first(10)
    end

    render json: ingredients.map { |i| { id: i.id, name: i.name } }
  end


  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :ciqual_code, :source, :energy_kcal, :proteins, :fats, :carbs, :sugars, :fibers, :food_group_id)
  end
end
