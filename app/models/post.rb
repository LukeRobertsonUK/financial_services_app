class Post < ActiveRecord::Base
  include AASM

  validates :title, presence: true
  validates :sharing_pref, presence: true

  belongs_to :user
  has_many :attachments
  has_many :comments
  has_many :post_viewings
  attr_accessible :colleague_visible, :content, :non_investor_visible, :post_file, :sharing_pref, :title, :user_id, :tag_list, :tag_tokens, :attachments_attributes
  attr_reader :tag_tokens
  accepts_nested_attributes_for :attachments
  default_scope order('updated_at DESC')
  acts_as_taggable
  acts_as_votable
  before_destroy :delete_comments_and_admin_messages

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

def delete_comments_and_admin_messages
  Comment.where(post_id: self.id).each{|comment| comment.destroy}
  AdminMessage.where({subject_id: self.id, subject_class: "Post"}).each{|message| message.destroy}
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


def tag_string
    tags.map{|tag| tag.name}.join(", ")
end

def tag_tokens=(ids)
  tags = ids.split(",")
  tags.reject! {|id| id.to_i == 0}
  new_tags = ids.split(",").select{|id| id.to_i == 0}.map{|string| string[7..-5]}
  r_tags = []
  r_tags  += ActsAsTaggableOn::Tag.select(:name).find(tags).collect(&:name)
  self.tag_list = r_tags + new_tags
end


def shareable_with(user)
    poster_friendship_as_proposer = Friendship.where({proposer_id: self.user_id, proposee_id: user.id}).first
    poster_friendship_as_proposee = Friendship.where({proposee_id: self.user_id, proposer_id: user.id}).first

    return false if (user.business != "Investor" && self.non_investor_visible == false)
    return false if (self.user.firm == user.firm && self.colleague_visible == false)
        case sharing_pref
          when "Industry Participant" then
            if poster_friendship_as_proposer
              ['Kindred Spirit', 'Respected Peer', 'Industry Participant'].include?(poster_friendship_as_proposer.proposer_sharing_pref)
            elsif poster_friendship_as_proposee
              ['Kindred Spirit', 'Respected Peer', 'Industry Participant'].include?(poster_friendship_as_proposee.proposee_sharing_pref)
            end
          when "Respected Peer" then
            if poster_friendship_as_proposer
              ['Kindred Spirit', 'Respected Peer'].include?(poster_friendship_as_proposer.proposer_sharing_pref)
            elsif poster_friendship_as_proposee
              ['Kindred Spirit', 'Respected Peer'].include?(poster_friendship_as_proposee.proposee_sharing_pref)
            end
          when "Kindred Spirit" then
            if poster_friendship_as_proposer
              poster_friendship_as_proposer.proposer_sharing_pref == "Kindred Spirit"
            elsif poster_friendship_as_proposee
              poster_friendship_as_proposee.proposee_sharing_pref == "Kindred Spirit"
            end
          else
            return false
        end

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

  def visibility
    case sharing_pref
    when "Kindred Spirit" then "Kindred Spirits only."
    when "Respected Peer" then "Kindred Spirits and Respected Peers."
    when "Industry Participant" then "Kindred Spirits, Respected Peers and Industry Participants."
    end
  end


end
