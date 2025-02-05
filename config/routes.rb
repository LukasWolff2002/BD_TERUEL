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
  resources :receptions
  resources :inventories
  resources :inventorie_histories
  resources :sectors do
    get 'varieties', on: :member
  end
  resources :varieties, only: [:show]
  resources :irrigations
  resources :harvests
end
