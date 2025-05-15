class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> { active_admin_controller? }

  private

  def active_admin_controller?
    self.class < ActiveAdmin::BaseController
  end
end
