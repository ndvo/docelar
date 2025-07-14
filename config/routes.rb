# frozen_string_literal: true

Rails.application.routes.draw do
  resources :taggeds
  resources :notes
  resources :tags
  resource :session
  resources :passwords, param: :token
  resources :patients
  resources :medication_products
  resources :medications
  resources :pharmacotherapies
  resources :treatments
  resources :cards do
    match :pay, via: [:patch, :post, :put], on: :member
  end
  resources :dogs
  resources :tasks do
    post :bulk_update, on: :collection
  end
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
    post :generate_photos, on: :member
  end

  resources :articles do
    resources :comments
  end

  resources :photos
end
