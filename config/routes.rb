Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Rutas de sesión
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Defines the root path route ("/")
  root 'home#index'

  resources :users
  resources :images
  resources :receptions do
    collection do
      get 'informe'
    end
  end
  resources :inventories
  resources :inventorie_histories
  resources :sectors do
    get 'varieties', on: :member
    member do
      get :edit_varieties
      patch :update_varieties
    end
  end
  resources :varieties, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :irrigations
  resources :harvests
  resources :colors
  resources :applications
  resources :suppliers
  resources :agrochemical_divisions
  resources :agrochemicals do
    member do
      get 'edit_quantity'
      patch 'update_quantity'
    end
  end
  resources :agrochemical_histories, only: [:index, :new, :create]
end
