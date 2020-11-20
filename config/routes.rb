Rails.application.routes.draw do
  mount API::Base, at: "/"
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
    root "products#index"
    devise_for :users, skip: :omniauth_callbacks
    resources :products
    resources :carts
    resources :orders
    resources :orders_history, only: %i(index show)
    namespace :admins do
      root "products#index"
      resources :products
      resources :users
      resources :orders
    end
  end
end
