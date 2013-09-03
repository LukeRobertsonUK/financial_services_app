class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, except: [:tag_count, :tag_count_post]

  def tag_count
    @tag_count_user = User.tag_counts_on(:investment_styles).map {|tag| {text: tag.name, weight: tag.count}}

    render json: @tag_count_user
  end

  def tag_count_post
    @tag_count_post = Post.tag_counts_on(:tags).map {|tag| {text: tag.name, weight: tag.count}}
    render json: @tag_count_post
  end

end

