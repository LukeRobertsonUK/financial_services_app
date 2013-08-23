class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :biography, :user_image, :disclaimer, :business
  # attr_accessible :title, :body
  has_many :friendships_as_proposer, class_name: "Friendship", foreign_key: :proposer_id
  has_many :friendships_as_proposee, class_name: "Friendship", foreign_key: :proposee_id

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
