class UsersController < ApplicationController

  def index
    @users = User.all
    @current_users_friends = current_user.all_friends
    @visible_users = @users - @current_users_friends - [current_user]

    respond_to do |format|
      format.html # index.html.erb

    end
  end

  def raise_flag
    @user = User.find(params[:id])
    current_user.raise_flag(@user)
    redirect_to red_flags_path
  end

  def lower_flag
    @user = User.find(params[:id])
    current_user.lower_flag(@user)
    redirect_to red_flags_path
  end

  def support_user
    @user = User.find(params[:id])
    current_user.vote_in_favour_of(@user)
    redirect_to red_flags_path
  end

  def remove_support
    @user = User.find(params[:id])
    current_user.remove_favourable_vote_for(@user)
    redirect_to red_flags_path
  end

  def admin_vote_reset
    @user = User.find(params[:id])
    current_user.manual_vote_reset_for(@user)
    redirect_to red_flags_path
  end

end