Rails.application.routes.draw do
  resources :payments
  resources :purchases
  resources :products
  # https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'sign_up' => 'users#new', as: 'sign_up'
  get 'login' => 'session#new', as: 'login'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy', as: 'logout'

  resources :countries
  resources :people
  resources :quotes
  resources :session
  resources :users

  resources :articles do
    resources :comments
  end
end
