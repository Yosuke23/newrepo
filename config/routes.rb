Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'account_activations/edit'
  # get 'users/new'
  root 'static_pages#home'
  get  '/privacy',    to: 'static_pages#privacy'
  get  '/about',   to: 'static_pages#about'
  get  '/terms', to: 'static_pages#terms'
  get  '/info', to: 'static_pages#info'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  #↑なぜかチュートリアルで削除されてる?
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do 
    member do
     get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only:      [:create, :destroy]
  resources :relationships, only:    [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get '/auth/failure',               to: 'users#auth_failure',        as: :auth_failure
  get '/auth/:provider/callback',    to: 'sessions#facebook_login',      as: :auth_callback
end
