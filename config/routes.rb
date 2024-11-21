Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_scope :user do
    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  
    authenticated :user do
      root 'menus#index'
    end
  end

  resources :search_orders, only: [:index] do
    get 'search', on: :collection
  end
  resources :users, only: [:show]

  resources :pre_registers, only: [:index, :new, :create]

  resources :restaurants, only: [:new, :create, :edit, :update, :show] do
    resources :operating_hours, only: [:new, :create, :edit, :update, :show]
    resources :menus, only: [:index, :new, :create, :edit, :update, :show]
    resources :positions, only: [:index, :new, :create]
    get 'price_history', to: 'price_histories#index'
  end

  resources :items, only: [:index, :show] do
    get 'search', on: :collection
    get 'filter', on: :collection
    post 'activated', on: :member
    post 'deactivated', on: :member
    get 'price_history', to: 'price_histories#show'
    resources :portions, only: [:show, :new, :create, :edit, :update] do
      get 'price_history', to: 'price_histories#details'
    end
  end

  resources :dishes, only: [:new, :create, :edit, :update]
  resources :beverages, only: [:new, :create, :edit, :update]
  resources :tags

  resources :orders, only: [:index, :new, :create, :show] do
    resources :order_portions, only: [:new, :create, :edit, :update]
    post 'confirming', on: :member
    post 'preparing', on: :member
    post 'done', on: :member
    post 'delivered', on: :member
    post 'canceled', on: :member
  end

  resources :discounts do 
    get 'list', on: :collection
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
        get 'restaurants/:restaurant_code/orders', to: 'orders#index'
        get 'restaurants/:restaurant_code/orders/:order_code', to: 'orders#show'
        patch 'restaurants/:restaurant_code/orders/:order_code/preparing', to: 'orders#update_to_preparing'
        patch 'restaurants/:restaurant_code/orders/:order_code/done', to: 'orders#update_to_done'
        patch 'restaurants/:restaurant_code/orders/:order_code/canceled', to: 'orders#update_to_canceled'
    end
  end
end
