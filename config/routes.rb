# frozen_string_literal: true

Rails.application.routes.draw do
  resources :dogs
  resources :tasks
  root 'home#index'

  get 'sign_up' => 'users#new', as: 'sign_up'
  get 'login' => 'session#new', as: 'login'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy', as: 'logout'

  resources :countries
  resources :payments
  resources :people
  resources :products
  resources :purchases do
    post :set_installments, on: :collection
  end
  resources :quotes
  resources :session
  resources :users

  resources :galleries do
    post :find_new_galleries, on: :collection
  end

  resources :articles do
    resources :comments
  end
end
