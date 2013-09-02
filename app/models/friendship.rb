class Friendship < ActiveRecord::Base
  belongs_to :proposer, class_name: "User"
  belongs_to :proposee, class_name: "User"
  attr_accessible :proposee_sharing_pref, :proposer_sharing_pref, :proposee_id, :proposer_id, :confirmed
  validates_uniqueness_of :proposer_id, scope: [:proposee_id]
  validate :reciprocal_friendship_doesnt_exist




  def is_confirmed?
    if self.confirmed == true
      true
    else
      false
    end
  end

  def reciprocal_friendship_doesnt_exist
    reciprocal_friendships = Friendship.where({proposer_id: self.proposee_id, proposee_id: self.proposer_id})
    if reciprocal_friendships.any?
      errors.add(:base, "You already have a friend request from #{proposee.full_name}")
    end
  end



end
