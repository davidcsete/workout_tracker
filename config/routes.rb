Rails.application.routes.draw do
  get "dashboard/index"
  resources :exercise_trackings
  resources :exercises
  root to: 'workout_plans#index'
  devise_for :users
  resources :workout_plans do
    resources :exercises, only: [:index] do
      resources :exercise_trackings, only: [:new, :create]
    end
  end
  get "dashboard", to: "dashboard#index"
  post "/chatbots", to: "chatbots#create"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
