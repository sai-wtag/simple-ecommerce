Rails.application.routes.draw do
  devise_for :users do
  delete '/users/sign_out' => 'devise/sessions#destroy'
end

  root to: "home#index" 
end
