Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', controller: "videos", action: "index"
  resources :videos, only: [:show] do
    collection do
      post "search", to: "videos#search"
    end
  end
  resources :categories, only: [:show]

  get '/register', to: "users#new"
  get '/sign_in', to: "sessions#new"
end
