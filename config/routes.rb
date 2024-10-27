Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: "home#index"
  resources :restaurants, only: [:new, :create, :edit, :update, :show] do
    resources :operating_hours, only: [:new, :create, :edit, :update, :show]
  end
  resources :items, only: [:index, :show]
  resources :dishes 
  resources :beverages
 
end
