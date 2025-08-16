Rails.application.routes.draw do
  resources :diet_goals, except: [ :destroy ] do
    member do
      patch :regenerate
    end
  end
  resources :food_items
  resources :meals do
    resources :food_items, only: [ :new, :create, :edit, :update, :destroy ]
  end
  resources :foods do
    collection do
      get :search
    end
  end

  resources :recipes do
    member do
      post :copy
      get :add_to_meal
    end
  end

  post "recipes/:recipe_id/add_to_meal", to: "recipes#create_meal_from_recipe", as: :create_meal_from_recipe

  resources :home, only: [ :index ]
  resources :user_details, only: [ :new, :create, :edit, :update ]
  get "dashboard/index"
  resources :exercise_trackings
  resources :exercises
  root to: "home#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :workout_plans do
    member do
      post :duplicate
    end
    resources :exercises, only: [ :index, :new, :create, :edit, :update ] do
      resources :exercise_trackings, only: [ :new, :create ]
    end
    resources :workout_plan_exercises, only: [ :destroy ]
  end
  namespace :api do
    resources :exercise_trackings, only: [ :index ]
    resources :barcodes, only: [ :index ]
    resources :foods, only: [ :index, :create ]
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
