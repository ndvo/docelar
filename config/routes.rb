Rails.application.routes.draw do
  # https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'sign_up' => 'users#new', as: 'sign_up'

  resources :users
  resources :articles do
    resources :comments
  end
end
