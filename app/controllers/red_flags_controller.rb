class RedFlagsController < ApplicationController
# load_and_authorize_resource

  def index
    # @flagged_users = ActsAsVotable::Vote.where(vote_scope: "red_flag").map{|vote| vote.votable}.uniq
    @flagged_users = User.where(aasm_state: "wall_of_shamed").sort_by{|user| user.red_flag_balance_for_display}.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flagged_users }
    end
  end



end