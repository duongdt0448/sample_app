Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "/help", to: "static_pages#help"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :microposts, only: %i(create destroy) do
      collection do
        get :search_elastic
      end
    end

    resources :users do
      member do
        get :following, :followers
      end
    end

    resources :relationships, only: %i(create destroy)

    root "static_pages#home"
  end
end
