# frozen_string_literal: true

Rails.application.routes.draw do
  resources :notes
  resources :tags
  resource :session
  resources :passwords, param: :token
  resources :patients do
    get :medications, on: :member
    resources :treatments
    resources :medical_appointments do
      get :prepare, on: :member
      patch :update_checklist, on: :member
      get :follow_up, on: :member
    end
    resources :medical_exams
    resources :exam_requests
    resources :medical_conditions
    resources :family_medical_histories
  end
  get 'medications/dashboard', to: 'patients#dashboard', as: 'medication_dashboard'
  resources :medication_products
  resources :medications
  resources :pharmacotherapies
  resources :treatments
  resources :medication_administrations, only: [:update]
  resources :medication_reminders, only: [:show, :update, :destroy]
  resources :cards do
    match :pay, via: [:patch, :post, :put], on: :member
  end
  resources :dogs
  resources :tasks do
    post :bulk_update, on: :collection
    get :summary, on: :collection
  end
  resources :responsibles, only: [:create]

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

  resources :tagged_photos

  resources :photos

  namespace :oauth do
    get :google_photos, to: 'google_photos#connect', as: 'google_photos'
    get :google_photos_callback, to: 'google_photos#callback', as: 'google_photos_callback'
    delete :google_photos, to: 'google_photos#disconnect', as: 'google_photos_disconnect'
    post :google_photos_refresh, to: 'google_photos#refresh_token', as: 'google_photos_refresh'
    resources :google_photos_albums, only: [:index]
    post :google_photos_albums_import, to: 'google_photos_albums#import', as: 'google_photos_albums_import'
  end
end
