Rails.application.routes.draw do
  root 'static_pages#index'
  mount Buttercms::Engine => '/blog'

  resources :genres
  resources :casts, defaults: {:format => 'json'}

  resources :sessions, only: [:new, :create]
  delete '/sessions' => 'sessions#destroy'

  resources :dramas, only: [:index, :show], defaults: {:format => 'json'}

  post '/dramas/:drama_id/add' => 'dramas#add', as: 'add_to_list'

  resources :users, defaults: {:format => 'json'} do
    member do
      get :following, :followers
    end
    resources :lists
  end

  resources :relationships, only: [:create, :destroy]

  resources :reviews, only: [:create, :update, :destroy]

  get 'search', to: 'search#search'
end