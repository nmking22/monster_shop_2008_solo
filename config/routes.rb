Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # merchants
  # resources
  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end
  # hand rolled
  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  post '/merchants', to: 'merchants#create'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'

  # items
  # resources
  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end
  # hand rolled
  # get '/items', to: 'items#index'
  # get '/items/:id', to: 'items#show'
  # get '/items/:id/edit', to: 'items#edit'
  # patch '/items/:id', to: 'items#update'
  # delete '/items/:id', to: 'items#destroy'
  # get '/items/:item_id/reviews/new', to: 'reviews#new'
  # post '/items/:item_id/reviews/create', to: 'reviews#create'

  # reviews
  # resources
  # resources :reviews, only: [:edit, :update, :destroy]
  # hand rolled
  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  # orders
  # resources
  # resources :orders, only: [:new, :create, :show]
  # hand rolled
  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show'

  # users
  # resources - most of these can't be handrolled with the way the controllers were set up
  # namespace :profile do
  #   resources :orders, only: [:show, :update]
  # end
  # hand rolled
  get '/register', to: "users#new"
  post '/register', to: "users#create"
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/orders', to: 'users_orders#index'
  get '/profile/orders/:id', to: 'orders#show'
  patch '/profile/orders/:id', to: 'orders#update'

  # password
  # resources - can't be done here since the routes are not RESTful
  # hand rolled
  get '/password/edit', to: 'password#edit'
  patch '/password', to: 'password#update'

  # sessions
  # resources - can't be done here since the routes are not RESTful
  # hand rolled
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/', to: 'sessions#destroy'

  # cart
  # resources - can't be done here since the routes are not RESTful
  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id/increment", to: "cart#increment"
  patch "/cart/:item_id/decrement", to: "cart#decrement"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  # hand rolled

  # admin
  namespace :admin do
    # resources
    resources :merchants, only: [:index, :show, :update]
    # hand rolled
    # get '/merchants', to: 'merchants#index'
    # get '/merchants/:id', to: 'merchants#show'
    # patch '/merchants/:id', to: 'merchants#update'

    get '/', to: 'dashboard#index'
    get '/users', to: 'users_dashboard#index'
    get '/users/:id', to: 'users_dashboard#show'
    patch '/users/:id/orders/:order_id', to:'users_dashboard#update'
  end

  # merchant
  # resources
  namespace :merchant do
    get '/', to: 'dashboard#show'
    resources :items
    resources :item_orders, only: [:update]
    resources :orders, only: [:show]
    resources :discounts
  end
  # hand rolled
  namespace :merchant do
    get '/', to: 'dashboard#show'
    # resources :items
    get '/items', to: 'items#index'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    get '/items/:id', to: 'items#show'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'
    # resources :item_orders, only: [:update]
    patch '/item_orders/:id', to: 'item_orders#update'
    # resources :orders, only: [:show]
    get '/orders/:id', to: 'orders#show'
    # resources :discounts
    get '/discounts', to: 'discounts#index'
    get '/discounts/new', to: 'discounts#new'
    post '/discounts', to: 'discounts#create'
    get '/discounts/:id', to: 'discounts#show'
    get '/discounts/:id/edit', to: 'discounts#edit'
    patch '/discounts/:id', to: 'discounts#update'
    delete '/discounts/:id', to: 'discounts#destroy'
  end
end
