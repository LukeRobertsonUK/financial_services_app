FinancialServicesApp::Application.routes.draw do

  resources :comments do
    member do
      post 'mark_inappropriate', to: "comments#mark_inappropriate"
      post 'reset_comment_vote', to: "comments#reset"
    end
  end

  resources :admin_messages do
    get 'page/:page', action: :index, on: :collection
    member do
      post "mark_resolved", to: "admin_messages#mark_resolved"
    end
  end

  resources :posts do
    # get :autocomplete_tag_name, :on => :collection
    member do
      post 'mark_inappropriate', to: "posts#mark_inappropriate"
      post 'reset_post_vote', to: "posts#reset"
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
  get '/tag_count.json', to: 'application#tag_count', format: false
  get '/tag_count_post.json', to: 'application#tag_count_post', format: false
  root to: "users#index"



end
