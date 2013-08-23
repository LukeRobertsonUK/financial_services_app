FinancialServicesApp::Application.routes.draw do

  resources :posts


  resources :firms


  resources :friendships
  resources :friends

  devise_for :users

  get '/users', to: "users#index", as: 'users'

  root to: "users#index"


end
