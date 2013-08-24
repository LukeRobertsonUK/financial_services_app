class RedFlagsController < ApplicationController


  def index
    @flagged_users = ActsAsVotable::Vote.where(vote_scope: "red_flag").map{|vote| vote.votable}.uniq

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flagged_users }
    end
  end



end