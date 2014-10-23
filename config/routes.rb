Rails.application.routes.draw do
  devise_for :users

  resources :payments, only: [:new, :create]
end
