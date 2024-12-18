Rails.application.routes.draw do
  // ... existing code ...
  
  resources :documents do
    member do
      post :send_for_signature
      get :preview
    end
    resources :signatures, only: [:create]
  end

  // ... existing code ...
end 