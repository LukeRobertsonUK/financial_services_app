class UsersController < ApplicationController

    def index
    @users = User.all
    @current_users_friends = current_user.all_friends
    @visible_users = @users - @current_users_friends - [current_user]

    respond_to do |format|
      format.html # index.html.erb

    end
  end


end