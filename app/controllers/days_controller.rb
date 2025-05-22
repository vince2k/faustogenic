class DaysController < ApplicationController
  before_action :set_day, only: [:show, :edit, :update, :destroy]

  def index
    @days = current_user.days.all.order(date: :desc)
  end

  def show
  end

  def new
    @day = current_user.days.build(date: Date.today)
  end

  def create
    existing = current_user.days.find_by(date: day_params[:date])

    if existing
      redirect_to existing, alert: "Ce jour existe déjà."
    else
      @day = current_user.days.build(day_params)

      if @day.save
        # (optionnel) Créer des repas par défaut
        ["Petit déjeuner", "Déjeuner", "Goûter", "Dîner"].each do |name|
          @day.meals.create!(user: current_user, name: name)
        end

        redirect_to @day, notice: "Journée créée avec ses repas."
      else
        render :new
      end
    end
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    @day = Day.find(params[:id])
    if @day.update(day_params)
      redirect_to @day, notice: 'Day was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @day = Day.find(params[:id])
    @day.destroy
    redirect_to days_url, notice: 'Day was successfully destroyed.'
  end

  private

  def day_params
    params.require(:day).permit(:date)
  end

  def set_day
    @day = current_user.days.find(params[:id])
  end
end
