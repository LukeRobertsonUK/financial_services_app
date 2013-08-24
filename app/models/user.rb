class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :biography, :user_image, :disclaimer, :business, :firm_id, :firm_attributes, :tag_list, :investment_style_list
  # attr_accessible :title, :body
  has_many :friendships_as_proposer, class_name: "Friendship", foreign_key: :proposer_id
  has_many :friendships_as_proposee, class_name: "Friendship", foreign_key: :proposee_id
  has_many :posts
  belongs_to :firm
  accepts_nested_attributes_for :firm
  acts_as_taggable
  acts_as_taggable_on "investment_styles"
  acts_as_votable


  INDUSTRY_INVOLVEMENTS = ["Investor", "Broker", "Banker", "Journalist", "Corporate"]
  SHARING_PREFERENCES = ['Kindred Spirit', 'Respected Peer', 'Industry Participant']
  INVESTMENT_STYLES = {
    "Market Capitalization" => ["Mega-cap", "Large-cap", "Mid-cap", "Small-cap", "Micro-cap"],
    "Region" => ["Global", "EAFE", "Developed", "Emerging", "Europe", "Asia ex-Japan", "Japan", "Country", "Latin America"],
    "Time Horizon" => ["Very Long", "Long", "Medium", "Short", "Very Short", "Intra-day"],
    "Style" => ["Value", "Growth", "GARP", "Blend", "Active", "Passive", "Quant", "Long-only", "Hedge", "Arbitrage"]
  }
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
  end

  def lower_flag(user)
    user.unliked_by :voter => self, vote_scope: "red_flag"
  end

  def vote_in_favour_of(user)
    user.downvote_from self, vote_scope: "red_flag"
  end

  def remove_favourable_vote_for(user)
    user.undisliked_by :voter => self, vote_scope: "red_flag"
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

end
