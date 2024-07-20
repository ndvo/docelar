# frozen_string_literal: true

Rails.application.routes.draw do
  resources :patients
  resources :cards
  resources :dogs
  resources :tasks
  root 'home#index'

  get 'sign_up' => 'users#new', as: 'sign_up'
  get 'login' => 'session#new', as: 'login'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy', as: 'logout'

  resources :countries
  resources :payments do
    post :payments_bulk_update, on: :collection
  end
  resources :people
  resources :products
  resources :purchases do
    post :payments_bulk_update, on: :member
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
