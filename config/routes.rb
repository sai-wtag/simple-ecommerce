Rails.application.routes.draw do
  devise_for :users
  
  get '/my-orders', to: 'orders#my_orders', as: 'my_orders'
  put '/cancel-order/:id', to: 'orders#cancel_order', as: 'cancel_order'

  resources :items, :orders

  root to: "home#index" 
end
