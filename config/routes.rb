FinancialServicesApp::Application.routes.draw do

  resources :comments


  resources :posts
  resources :red_flags

  resources :firms


  resources :friendships do
    member do
      post :update_sharing_pref, to: 'friendships#update_sharing_pref'
    end
  end



  resources :friends

  devise_for :users, controllers: { registrations: 'registrations' }

  get '/users', to: "users#index", as: 'users'
  get '/raise_flag', to: "users#raise_flag", as: 'raise_flag'
  get '/lower_flag', to: "users#lower_flag", as: 'lower_flag'
  get '/support_user', to: "users#support_user", as: 'support_user'
  get '/remove_support', to: "users#remove_support", as: 'remove_support'

  root to: "users#index"


end
