Rails.application.routes.draw do
  devise_for :users
  
  mount Base => '/'

  get '/my-orders', to: 'orders#my_orders', as: 'my_orders'
  put '/cancel-order/:id', to: 'orders#cancel_order', as: 'cancel_order'
  put '/change-order-status/:id', to: 'orders#change_order_status', as: 'change_order_status'

  resources :items, :orders

  root to: "home#index" 
end
