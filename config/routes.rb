Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'ui(/:action)', controller: 'ui'
  get '/front', to: "pages#front"
  resources :videos, only: [:index, :show] do
    collection do
      post "search", to: "videos#search"
    end
  end
  resources :categories, only: [:show]
  resources :users, only: [:create]

  get '/register', to: "users#new"
  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"
  get '/home', to: "videos#index"
end
