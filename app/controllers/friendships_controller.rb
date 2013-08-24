class FriendshipsController < ApplicationController
  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
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
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
    @proposer = @friendship.proposer
    @proposee = @friendship.proposee
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(params[:friendship])
    current_user.un_black_ball(@friendship.proposee)
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to @friendship, notice: "Your Friend Request was sent" }
        format.json { render json: @friendship, status: :created, location: @friendship }
      else
        format.html { render action: "new" }
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
