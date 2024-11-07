Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # root to: "menus#index"

  devise_scope :user do
    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  
    authenticated :user do
      root 'menus#index'
    end
  end

  resources :users, only: [:show]

  resources :restaurants, only: [:new, :create, :edit, :update, :show] do
    resources :operating_hours, only: [:new, :create, :edit, :update, :show]
    resources :menus, only: [:index, :new, :create, :edit, :update, :show]
    resources :orders, only: [:index, :new, :create, :edit, :update, :show]
    get 'price_history', to: 'price_histories#index'
  end

  resources :items, only: [:index, :show] do
    get 'search', on: :collection
    get 'filter', on: :collection
    post 'activated', on: :member
    post 'deactivated', on: :member
    get 'price_history', to: 'price_histories#show'
    resources :portions, only: [:show, :new, :create, :edit, :update, :destroy] do
      get 'price_history', to: 'price_histories#details'
    end
  end

  resources :dishes, only: [:new, :create, :edit, :update, :destroy]
  resources :beverages, only: [:new, :create, :edit, :update, :destroy]
  resources :tags
end
