Rails.application.routes.draw do
  root "buckets#index"

  resource :first_run

  resource :session

  resource :account do
    scope module: "accounts" do
      resource :join_code

      resources :users
    end
  end

  get "join/:join_code", to: "users#new", as: :join
  post "join/:join_code", to: "users#create"

  resources :users do
    scope module: "users" do
      resource :avatar
    end
  end

  resources :buckets do
    resource :access, controller: "buckets/accesses"

    resources :bubbles do
      scope module: "bubbles" do
        resource :image
        resource :pop
      end

      resources :assignments
      resources :boosts
      resources :comments
      resources :tags, shallow: true
    end

    resources :tags, only: :index
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
