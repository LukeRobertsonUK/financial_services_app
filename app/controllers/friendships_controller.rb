class FriendshipsController < ApplicationController
  load_and_authorize_resource
  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end

  def update_sharing_pref

  @new_preference = case params["new_preference"]
    when "respected_peer" then "Respected Peer"
    when "kindred_spirit" then "Kindred Spirit"
    when "industry_participant" then "Industry Participant"
    when "purgatory" then "Purgatory"
    end
    @friend_id = params[:user_id]
    @friendship = (Friendship.where({proposer_id: current_user.id, proposee_id: @friend_id}) + Friendship.where({proposer_id: @friend_id, proposee_id: current_user.id})).first

    if @friendship.proposer == current_user
      @friendship.update_attributes(proposer_sharing_pref: @new_preference)
    else
      @friendship.update_attributes(proposee_sharing_pref: @new_preference)
    end


    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/new
  # GET /friendships/new.json
  def new
    @proposer = current_user
    @proposee = User.where(id: params[:proposee_id]).first
    @friendship = Friendship.new
    @friendship.proposer_id = @proposer.id
    @friendship.proposee_id = @proposee.id


    respond_to do |format|
      format.html # new.html.erb
      format.js {}
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
    @proposer = @friendship.proposer
    @proposee = @friendship.proposee
    respond_to do |format|
      format.html # new.html.erb
      format.js {}

    end
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(params[:friendship])
    current_user.un_black_ball(@friendship.proposee)
    respond_to do |format|
      if @friendship.save
        @grouped_friends = current_user.grouped_friends
        format.html { redirect_to @friendship, notice: "Your Friend Request was sent" }
        format.json { render json: @friendship, status: :created, location: @friendship }
        format.js {}
      else
        format.html { render action: "new" }
        @grouped_friends = current_user.grouped_friends
        format.js {}
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /friendships/1
  # PUT /friendships/1.json
  def update
    @friendship = Friendship.find(params[:id])
    (@friendship.is_confirmed? || @friendship.proposer == current_user) ? (friend_notice = "Friendship was successfully updated") :  (friend_notice = "You accepted the friend request")
    @friendship.confirmed = true unless @friendship.proposer == current_user
    respond_to do |format|
      if @friendship.update_attributes(params[:friendship])
        format.html { redirect_to @friendship, notice: friend_notice}
        format.json { head :no_content }
        format.js {}
      else
        format.html { render action: "edit" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy

    @friendship = Friendship.find(params[:id])

    if params[:black_ball]
      current_user.black_ball(@friendship.proposer)
    end

    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friendships_url }
      format.json { head :no_content }
    end
  end
end
