Rails.application.routes.draw do
  # https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'sign_up' => 'users#new', as: 'sign_up'
  get 'login' => 'session#new', as: 'login'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy', as: 'logout'

  resources :users
  resources :session

  resources :articles do
    resources :comments
  end
end
