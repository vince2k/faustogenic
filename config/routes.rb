# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :ingredients
  resources :days
  resources :meals, only: [:new, :create, :show]
  resources :dishes, only: [:create]
  resources :dish_ingredients, only: [:create, :edit, :update]



  namespace :api do
    namespace :v1 do
      get "ingredients/autocomplete", to: "ingredients#autocomplete"
    end
  end


  root to: "pages#home"
end
