class DishesController < ApplicationController
  def create
    @meal = Meal.find(params[:dish][:meal_id])
    name = params[:dish][:name].to_s.strip

    if name.blank?
      redirect_to day_path(@meal.day), alert: "Le nom du plat ne peut pas être vide." and return
    end

    @dish = @meal.dishes.create(name: name)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to day_path(@meal.day), notice: "Plat ajouté." }
    end
  end

  private

  def dish_params
    params.require(:dish).permit(:name)
  end
end
