class Comment < ActiveRecord::Base
  include AASM
  belongs_to :user
  belongs_to :post
  attr_accessible :comment_file, :content, :user_id, :post_id, :visible_poster_only
  acts_as_votable

  aasm do
  state :ok, initial: true
  state :inappropriate, :before_enter => :generate_inappropriate_admin_alert

  event :make_inappropriate do
    transitions :from => :ok, :to => :inappropriate

  end

  event :make_ok do
    transitions :from => :inappropriate, :to => :ok

  end

end

def generate_inappropriate_admin_alert
  AdminMessage.create({
    subject_id: self.id,
    subject_class: self.class.name,
    content: "Marked Inappropriate"
  })
end





def mark_as_inappropriate_by(user)
  self.upvote_from user, vote_scope: "inappropriate"
  unless self.aasm_state == "inappropriate"
      if votes_at_manual_reset
        self.make_inappropriate! if (self.votes.count - votes_at_manual_reset) == 5
        self.save!

      else
        self.make_inappropriate! if self.votes.count == 5
        self.save!

      end
    end
  end

  def manual_vote_reset_by(user)
    if user.role == "admin"
      self.make_ok!
      self.votes_at_manual_reset =self.votes.count
      self.save!

    end
  end

  def has_been_flagged_by(user)
    self.votes.where({voter_id: user.id}).size >0

  end





end
