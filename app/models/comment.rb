class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  attr_accessible :comment_file, :content, :user_id, :post_id, :visible_poster_only
end
