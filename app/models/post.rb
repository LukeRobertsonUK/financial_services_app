class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :colleague_visible, :content, :non_investor_visible, :post_file, :sharing_pref, :title, :user_id

def shareable_with(user)
    poster_friendship_as_proposer = Friendship.where({proposer_id: self.user_id, proposee_id: user.id}).first
    poster_friendship_as_proposee = Friendship.where({proposee_id: self.user_id, proposer_id: user.id}).first

    case sharing_pref
      when User::SHARING_PREFERENCES[2] then
        if poster_friendship_as_proposer
          User::SHARING_PREFERENCES.include?(poster_friendship_as_proposer.proposer_sharing_pref)
        elsif poster_friendship_as_proposee
          User::SHARING_PREFERENCES.include?(poster_friendship_as_proposee.proposee_sharing_pref)
        end
      when User::SHARING_PREFERENCES[1] then
        if poster_friendship_as_proposer
          User::SHARING_PREFERENCES.pop.include?(poster_friendship_as_proposer.proposer_sharing_pref)
        elsif poster_friendship_as_proposee
          User::SHARING_PREFERENCES.pop.include?(poster_friendship_as_proposee.proposee_sharing_pref)
        end
      when User::SHARING_PREFERENCES[0] then
        if poster_friendship_as_proposer
          poster_friendship_as_proposer.proposer_sharing_pref == User::SHARING_PREFERENCES[0]
        elsif poster_friendship_as_proposee
          poster_friendship_as_proposee.proposee_sharing_pref == User::SHARING_PREFERENCES[0]
        end
      else
        return false
    end
end


end
