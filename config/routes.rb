Rails.application.routes.draw do

  root 'items#index'
  devise_for :users

  resource :charity
  get 'dashboard' => 'charities#show', as: :dashboard
  
  resources :auctions
  post 'auctions/wrapup' => 'auctions#wrapup', as: :wrapup
  post 'confirm_payment' => 'payment_notifications#confirm_payment'

  resources :items do
    resources :bids, only: :create
    resources :watch_list_items, only: :create
  end
  resources :watch_list_items, only: [:index, :update, :destroy]

  get 'my_donations' => 'items#show_my_donations', as: :my_donations
  get 'review' => 'items#review' 

  
end
