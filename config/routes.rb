Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'

  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: "videos#search"
    end
  end
  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
end
