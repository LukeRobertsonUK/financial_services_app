FinancialServicesApp::Application.routes.draw do

  resources :comments do
    member do
      post 'mark_inappropriate', to: "comments#mark_inappropriate"
    end
  end

  resources :admin_messages

  resources :posts do
    # get :autocomplete_tag_name, :on => :collection
    member do
      post 'mark_inappropriate', to: "posts#mark_inappropriate"
    end
  end

  resources :red_flags

  resources :firms


      post 'raise_flag', to: "users#raise_flag"
      post 'lower_flag', to: "users#lower_flag"
      post 'support_user', to: "users#support_user"
      post 'remove_support', to: "users#remove_support"
      post 'admin_vote_reset', to: "users#admin_vote_reset"



  resources :friendships

  resources :friends

  devise_for :users, controllers: { registrations: 'registrations' }

  get '/users', to: "users#index", as: 'users'
  get '/users/:id', to: "users#show", as: 'user'
  post '/users/:user_id/friendships/update_sharing_pref', to: 'friendships#update_sharing_pref'


  get'/tags', to: "tags#index", as: 'tags'

  root to: "users#index"


end
