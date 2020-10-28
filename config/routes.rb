Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    devise_for :users
    resources :products
    resources :carts
    resources :orders
    resources :orders_history, only: %i(index show)
    namespace :admins do
      root "dashboard#index"
      resources :products
      resources :users
      resources :orders
    end
  end
end
