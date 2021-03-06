class Comment < ActiveRecord::Base
  include AASM
  validates :content, presence: true
  belongs_to :user
  belongs_to :post
  attr_accessible :comment_file, :content, :user_id, :post_id, :visible_poster_only
  acts_as_votable
  before_destroy :delete_admin_messages
  default_scope order('created_at DESC')

  aasm do
  state :ok, initial: true, :before_enter => :mark_admin_alert_resolved
  state :inappropriate, :before_enter => :generate_inappropriate_admin_alert

  event :make_inappropriate do
    transitions :from => :ok, :to => :inappropriate

  end

  event :make_ok do
    transitions :from => :inappropriate, :to => :ok

  end

end

def delete_admin_messages
  AdminMessage.where({subject_id: self.id, subject_class: "Comment"}).each{|message| message.destroy}
end



def generate_inappropriate_admin_alert
  AdminMessage.create({
    subject_id: self.id,
    subject_class: self.class.name,
    content: "marked inappropriate"
  })
end

def mark_admin_alert_resolved
  message = AdminMessage.where({
    subject_id: self.id,
    subject_class: self.class.name
    }).first

  (message.addressed_by_admin = true) if message
  message.save! if message

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
