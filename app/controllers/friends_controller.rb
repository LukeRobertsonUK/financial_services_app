class FriendsController < ApplicationController

    def index
      @incoming_friend_requests = Friendship.where({
          proposee_id: current_user.id,
          confirmed: nil
        })
      @confirmed_friends = current_user.confirmed_friends

    respond_to do |format|
    format.html # index.html.erb

    end
  end


end