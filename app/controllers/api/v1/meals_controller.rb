# app/controllers/api/v1/meals_controller.rb
module Api
  module V1
    class MealsController < BaseController
      def index
        @meals = current_user.meals.includes(:dishes)
        render json: @meals
      end

      def show
        @meal = current_user.meals.find(params[:id])
        render json: @meal
      end

      def create
        @meal = current_user.meals.new(meal_params)
        if @meal.save
          render json: @meal, status: :created
        else
          render json: { errors: @meal.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def meal_params
        params.require(:meal).permit(:name)
      end
    end
  end
end
