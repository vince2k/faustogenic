class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> { active_admin_controller? }
  before_action :configure_permitted_parameters, if: :devise_controller?


  private

  def configure_permitted_parameters
    # Autoriser les champs supplémentaires lors de l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :nickname, :avatar])

    # Autoriser les champs supplémentaires lors de la mise à jour du compte
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :nickname, :avatar])
  end

  def active_admin_controller?
    self.class < ActiveAdmin::BaseController
  end
end
