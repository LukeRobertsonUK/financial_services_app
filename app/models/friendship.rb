class Friendship < ActiveRecord::Base
  belongs_to :proposer, class_name: "User"
  belongs_to :proposee, class_name: "User"
  attr_accessible :proposee_sharing_pref, :proposer_sharing_pref, :proposee_id, :proposer_id, :confirmed

  def is_confirmed?
    if self.confirmed == true
      true
    else
      false
    end
  end

end
