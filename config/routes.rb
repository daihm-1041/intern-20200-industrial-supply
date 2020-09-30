Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :products
    resources :carts
    resources :orders
    namespace :admins do
      root "dashboard#index"
      resources :products
      resources :users
      resources :orders
    end
  end
end
