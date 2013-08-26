class Comment < ActiveRecord::Base
  include AASM
  belongs_to :user
  belongs_to :post
  attr_accessible :comment_file, :content, :user_id, :post_id, :visible_poster_only
  acts_as_votable

  aasm do
  state :ok, initial: true
  state :inappropriate

  event :make_inappropriate do
    transitions :from => :ok, :to => :inappropriate
  end

  event :make_ok do
    transitions :from => :inappropriate, :to => :ok
  end

end

def mark_as_inappropriate_by(user)
    self.upvote_from user, vote_scope: "inappropriate"
    if votes_at_manual_reset
      self.make_inappropriate if (self.votes.count - votes_at_manual_reset) == 5
      self.save!
    else
      self.make_inappropriate if self.votes.count == 5
      self.save!
    end
  end

  def manual_vote_reset_by(user)
    if user.role == "admin"
      self.make_ok
      self.votes_at_manual_reset =self.votes.count
      self.save!
    end
  end







end
