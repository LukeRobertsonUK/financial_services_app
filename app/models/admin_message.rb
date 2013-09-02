class AdminMessage < ActiveRecord::Base
  attr_accessible :addressed_by_admin, :seen_by_admin, :subject_class, :subject_id, :content
  default_scope order('created_at DESC')



  def subject_of_message
    case self.subject_class
      when "User" then User.find(subject_id)
      when "Comment" then Comment.find(subject_id)
      when "Post" then Post.find(subject_id)
    end
  end

  def message_string
    "#{self.created_at.to_formatted_s(:long_ordinal)}: #{subject_class} #{content}"
  end








end
