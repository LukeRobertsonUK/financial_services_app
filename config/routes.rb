FinancialServicesApp::Application.routes.draw do

  resources :friendships

  devise_for :users

  get '/users', to: "users#index", as: 'users'

  root to: "users#index"


end
