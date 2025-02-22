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
      get :informe
      get :export_confirm  # Nueva ruta para confirmar la exportación
      post :export, defaults: { format: :xlsx }  
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
    collection do
      get :export
    end
  end
  resources :varieties
  resources :irrigations
  resources :harvests do
    collection do
      get :chart_sectors
    end
  end
  resources :colors

  resources :applications do
    collection do
      post :preview
    end
  end

  resources :suppliers
  resources :agrochemical_divisions
  resources :tools do
    resources :tool_histories, only: [:index, :new, :create]
  end
  resources :tool_histories
  resources :fertilizers do
    resources :fertilizer_histories, only: [:index, :new, :create]
  end
  resources :fertilizer_histories
  resources :agrochemicals do
    member do
      get 'edit_quantity'
      patch 'update_quantity'
    end
  end
  resources :agrochemical_histories, only: [:index, :new, :create]

  
end
