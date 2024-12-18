Rails.application.routes.draw do
  devise_for :users
  
  root 'documents#index'

  resources :documents do
    member do
      post :send_for_signature
      get :preview
      get :edit_fields
      post :save_fields
    end
    resources :signatures, only: [:create]
  end

  resources :templates do
    member do
      post :duplicate
    end
  end

  resources :signatures, only: [:index, :show] do
    member do
      post :sign
      post :decline
    end
  end

  resources :notifications, only: [:index, :destroy] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end
end 