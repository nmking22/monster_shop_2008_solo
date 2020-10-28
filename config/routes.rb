Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # merchants
  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  # items
  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  # reviews
  resources :reviews, only: [:edit, :update, :destroy]

  # orders
  resources :orders, only: [:new, :create, :show]

  # users
  get '/register', to: "users#new"
  post '/register', to: "users#create"
  get '/profile', to: 'users#show'

  # sessions
  get '/login', to: 'sessions#new'

  # cart
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  namespace :admin do
    get '/', to: 'dashboard#index'
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
  end
end
