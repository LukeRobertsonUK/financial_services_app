class UsersController < ApplicationController
  load_and_authorize_resource
  def index

    @q = User.search(params[:q])
    @users = @q.result(:distinct => true)


    @current_users_friends = current_user.all_friends
    @visible_users = @users - @current_users_friends - [current_user]
    @tag_count = User.tag_counts_on(:investment_styles).map {|tag| {text: tag.name, weight: tag.count}}

    respond_to do |format|
      format.html # index.html.erb
      format.js {}
      format.json { render json: @tag_count }
    end
  end

def show
    @user = User.find(params[:id])
    @posts = @user.posts.reject!{|post| !post.shareable_with(current_user)}

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user }
    end
  end



  def raise_flag
    @user = User.find(params[:id])
    current_user.raise_flag(@user)
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_votes}.reverse
    @users = User.all
    @current_users_friends = current_user.all_friends
    @visible_users = @users - @current_users_friends - [current_user]
    respond_to do |format|
      format.js {}
    end
  end

  def lower_flag
    @user = User.find(params[:id])
    current_user.lower_flag(@user)
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_votes}.reverse
    @users = User.all
    @current_users_friends = current_user.all_friends
    @visible_users = @users - @current_users_friends - [current_user]
    respond_to do |format|
      format.js {}
    end
  end

  def support_user
    @user = User.find(params[:id])
    current_user.vote_in_favour_of(@user)
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_votes}.reverse
    respond_to do |format|
      format.js {}
    end
  end

  def remove_support
    @user = User.find(params[:id])
    current_user.remove_favourable_vote_for(@user)
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_votes}.reverse
    respond_to do |format|
      format.js {}
    end
  end

  def admin_vote_reset
    @user = User.find(params[:id])
    current_user.manual_vote_reset_for(@user)
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_votes}.reverse

    # redirect_to red_flags_path
    respond_to do |format|
      format.js {}
    end
  end

end