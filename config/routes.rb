Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:create, :destroy]

  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :show, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'my_queue', to: 'queue_items#index'
  get 'register', to: 'users#new'
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  resources :payments, only: [:new, :create]
end
