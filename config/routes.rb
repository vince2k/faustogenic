# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :meals
      resources :dishes
      resources :ingredients
      resources :recipes
      resources :days
    end
  end

  root to: "pages#home"
end
