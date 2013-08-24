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

end
