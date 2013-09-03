class FriendsController < ApplicationController
  # load_and_authorize_resource
    def index
      @incoming_friend_requests = Friendship.where({
          proposee_id: current_user.id,
          confirmed: nil
        })
      @confirmed_friends = current_user.confirmed_friends

      @grouped_friends = current_user.grouped_friends

      @number_of_incoming_friend_requests = @incoming_friend_requests.count

    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @number_of_incoming_friend_requests }
    end
  end


end