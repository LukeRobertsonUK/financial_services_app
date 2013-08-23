class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :colleague_visible, :content, :non_investor_visible, :post_file, :sharing_pref, :title
end
