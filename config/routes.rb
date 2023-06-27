Rails.application.routes.draw do
  devise_for :users

  resources :items, :orders

  root to: "home#index" 
end
