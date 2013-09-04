class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  include AASM
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :biography, :user_image, :disclaimer, :business, :firm_id, :firm_attributes, :tag_list, :investment_style_list, :user_image_cache, :remove_user_image
  # attr_accessible :title, :body

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :business, presence: true
  validates_associated :firm

  mount_uploader :user_image, UserImageUploader
  has_many :friendships_as_proposer, class_name: "Friendship", foreign_key: :proposer_id
  has_many :friendships_as_proposee, class_name: "Friendship", foreign_key: :proposee_id
  has_many :posts
  has_many :comments
  has_one :firm_as_editor, class_name: "Firm", foreign_key: :editor_id
  has_many :post_viewings
  belongs_to :firm
  accepts_nested_attributes_for :firm
  acts_as_taggable
  acts_as_taggable_on "investment_styles"
  acts_as_votable
  default_scope order('last_name')



  INDUSTRY_INVOLVEMENTS = ["Investor", "Broker", "Banker", "Journalist", "Corporate", "Recruiter", "Other"]
  SHARING_PREFERENCES = ['Kindred Spirit', 'Respected Peer', 'Industry Participant']
  INVESTMENT_STYLES = {
    "Asset Classes" => ["Equities", "Fixed Income", "Covertibles", "Futures & Options", "Commodities", "FX", "Rates"],
    "Market Capitalization" => ["Mega-cap", "Large-cap", "Mid-cap", "Small-cap", "Micro-cap"],
    "Region" => ["Global", "EAFE", "Developed Markers", "Emerging Markets", "Europe", "Asia ex-Japan", "Japan", "Country", "Latin America"],
    "Time Horizon" => ["Very Long Term", "Long Term", "Medium Term", "Short Term", "Very Short Term", "Intra-day"],
    "Style" => ["Value", "Growth", "GARP", "Blend", "Active", "Passive", "Quant", "Long-only", "Hedge", "Arbitrage"]
  }

def role?(role)
  self.role == role
end


aasm do
  state :ok, initial: true, :before_enter => :mark_admin_alert_resolved
  state :wall_of_shamed, :before_enter => :generate_wall_of_shame_admin_alert

  event :wall do
    transitions :from => :ok, :to => :wall_of_shamed
  end

  event :make_ok do
    transitions :from => :wall_of_shamed, :to => :ok
  end

end

  def generate_wall_of_shame_admin_alert
     AdminMessage.create({
      subject_id: self.id,
      subject_class: self.class.name,
      content: "added to Wall of Shame"
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

  def interests_string
    investment_styles.map{|style| style.name}.join(", ")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_read(post)
    ((PostViewing.where({user_id: self.id, post_id: post.id}).count > 0) || self == post.user) ? "read_post" : "unread_post"
  end



  def first_read(post)
    PostViewing.where({user_id: self.id, post_id: post.id}).first.created_at
  end

  def relationship_with(user)
    proposer = Friendship.where({proposer_id: self.id, proposee_id: user.id}).first
    proposee = Friendship.where({proposer_id: user.id, proposee_id: self.id}).first
    if proposer
      proposer.proposer_sharing_pref
    elsif proposee
      proposee.proposee_sharing_pref
    else
      "not friends"
    end
  end

  def has_posts?
    self.posts.count >0
  end

  def has_friends?
    (Friendship.where(proposer_id: self.id) + Friendship.where(proposee_id: self.id)).count > 0
  end

  def has_commented_on?(post)
    post.comments.map{|comment| comment.user}.include?(self)
  end

  def all_friends
   proposees = self.friendships_as_proposer.map {|friendship| friendship.proposee}
   proposers = self.friendships_as_proposee.map {|friendship| friendship.proposer}
   proposees + proposers
  end

 def confirmed_friends
   proposees = self.friendships_as_proposer.where({confirmed: true}).map {|friendship| friendship.proposee}
   proposers = self.friendships_as_proposee.where({confirmed: true}).map {|friendship| friendship.proposer}
   proposees + proposers
  end

  def proposer_friendships_grouped_by_sharing_pref
    grouped_friendships = self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}
  end

  def proposee_friendships_grouped_by_sharing_pref
    self.friendships_as_proposer.where({confirmed: true}).group_by{|friendship| friendship.proposer_sharing_pref}
  end

  # I know this method needs refactoring... I just needed to get it done.
  def grouped_friends
    friends = {"Industry Participant" => [], "Respected Peer" => [], "Kindred Spirit" => [], "Purgatory" => []}

    unless self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Industry Participant"].blank?
      friends["Industry Participant"] += self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Industry Participant"].map{|friendship| friendship.proposee}
    end
    unless self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Industry Participant"].blank?
      friends["Industry Participant"] += self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Industry Participant"].map{|friendship| friendship.proposer}
    end
    unless self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Respected Peer"].blank?
      friends["Respected Peer"] += self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Respected Peer"].map{|friendship| friendship.proposee}
    end
    unless self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Respected Peer"].blank?
      friends["Respected Peer"] += self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Respected Peer"].map{|friendship| friendship.proposer}
    end
    unless self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Kindred Spirit"].blank?
      friends["Kindred Spirit"] += self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Kindred Spirit"].map{|friendship| friendship.proposee}
    end
    unless self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Kindred Spirit"].blank?
      friends["Kindred Spirit"] += self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Kindred Spirit"].map{|friendship| friendship.proposer}
    end
    unless self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Purgatory"].blank?
      friends["Purgatory"] += self.friendships_as_proposer.group_by{|friendship| friendship.proposer_sharing_pref}["Purgatory"].map{|friendship| friendship.proposee}
    end
    unless self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Purgatory"].blank?
      friends["Purgatory"] += self.friendships_as_proposee.where({confirmed: true}).group_by{|friendship| friendship.proposee_sharing_pref}["Purgatory"].map{|friendship| friendship.proposer}
    end
    friends["Industry Participant"].sort_by!{|user| user.last_name} unless friends["Industry Participant"].blank?
    friends["Respected Peer"].sort_by!{|user| user.last_name} unless friends["Respected Peer"].blank?
    friends["Kindred Spirit"].sort_by!{|user| user.last_name} unless friends["Kindred Spirit"].blank?
    friends["Purgatory"].sort_by!{|user| user.last_name} unless friends["Purgatory"].blank?
    friends
  end

  def friends_visible_posts
    proposees = self.friendships_as_proposer.map {|friendship| friendship.proposee}
    proposee_posts = proposees.map{|proposee| proposee.posts}.flatten

    proposers = self.friendships_as_proposee.map {|friendship| friendship.proposer}
    proposer_posts = proposers.map{|proposer| proposer.posts}.flatten

    posts = proposer_posts + proposee_posts
    posts.select{|post| post.shareable_with(self)}
  end

  def black_ball(user)
    user.vote voter: self, vote_scope: "black_ball"
  end

  def un_black_ball(user)
    user.unvote voter: self, vote_scope: "black_ball"
  end

  def number_of_black_balls
    self.find_votes(vote_scope: "black_ball").where(created_at: 30.days.ago..Time.now).size
  end

  def exceeds_black_ball_limit?
    number_of_black_balls >= 10
  end

  def raise_flag(user)
    user.upvote_from self, vote_scope: "red_flag"
    unless user.aasm_state == "wall_of_shamed"
      if user.votes_at_manual_reset
        user.wall! if (user.red_flag_balance - user.votes_at_manual_reset) == 5
        user.save!
      else
        user.wall! if user.red_flag_balance == 5
        user.save!
      end
    end
  end

  def lower_flag(user)
    user.unliked_by :voter => self, vote_scope: "red_flag"

    unless user.aasm_state == "ok"
      if user.votes_at_manual_reset
        user.make_ok! if (user.red_flag_balance - user.votes_at_manual_reset) == 0
        user.save!
      else
        user.make_ok! if user.red_flag_balance == 0
        user.save!
      end
    end
  end

  def vote_in_favour_of(user)
    user.downvote_from self, vote_scope: "red_flag"
    unless user.aasm_state == "ok"
      if user.votes_at_manual_reset
        user.make_ok! if (user.red_flag_balance - user.votes_at_manual_reset) == 0
        user.save!
      else
        user.make_ok! if user.red_flag_balance == 0
        user.save!
      end
    end
  end

  def remove_favourable_vote_for(user)
    user.undisliked_by :voter => self, vote_scope: "red_flag"
    unless user.aasm_state == "wall_of_shamed"
      if user.votes_at_manual_reset
        user.wall! if (user.red_flag_balance - user.votes_at_manual_reset) == 5
        user.save!
      else
        user.wall! if user.red_flag_balance == 5
        user.save!
      end
    end
  end

  def manual_vote_reset_for(user)
    if self.role == "admin"
      user.make_ok!
      user.votes_at_manual_reset =user.red_flag_balance
      user.save!
    end
  end

  def has_blackballed?(user)
     user.votes.where({voter_id: self.id, vote_scope: "black_ball", vote_flag: true}).size > 0
  end

  def has_raised_flag_against(user)
    user.votes.where({voter_id: self.id, vote_scope: "red_flag", vote_flag: true}).size > 0
  end

  def has_voted_in_defence_of(user)
    user.votes.where({voter_id: self.id, vote_scope: "red_flag", vote_flag: false}).size >0
  end

  def has_voted_on(user)
    has_voted_in_defence_of(user) || has_raised_flag_against(user)
  end

  def red_flag_votes
    self.upvotes(:vote_scope => 'red_flag').size
  end

  def favourable_votes
    self.downvotes(:vote_scope => 'red_flag').size
  end

  def red_flag_balance
     red_flag_votes - favourable_votes
  end

  def red_flag_balance_for_display
    self.votes_at_manual_reset ? (self.red_flag_balance - self.votes_at_manual_reset) : self.red_flag_balance
  end

  def user_written_tags
    investment_style_list.reject {|item| INVESTMENT_STYLES.values.flatten.include?(item)}
  end

  def connected_with(user)
    (Friendship.where({proposee_id: self.id, proposer_id: user.id}) + Friendship.where({proposee_id: user.id, proposer_id: self.id})).count > 0
  end
end
