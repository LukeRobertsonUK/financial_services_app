class CommentsController < ApplicationController
  load_and_authorize_resource
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

 def mark_inappropriate
    @comment = Comment.find(params[:id])
    @comment.mark_as_inappropriate_by(current_user)
    respond_to do |format|
      format.js {}
    end
  end

  def reset
    @comment = Comment.find(params[:id])
    @comment.manual_vote_reset_by(current_user)
    @post = @comment.post
    # redirect_to post_path(@comment.post)
    respond_to do |format|
      format.js {}
    end
  end


  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    @post_id = params[:post_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @post_id = @comment.post_id
    @post = @comment.post

    respond_to do |format|
      format.html # new.html.erb
      format.js {}
      format.json { render json: @comment }
    end
  end

  # POST /comments
  # POST /comments.json
  def create

    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        @post = Post.find(@comment.post_id)
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.js {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    @post = @comment.post

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.js {
          @comment= Comment.new
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy

    respond_to do |format|
      format.js{}
      format.html { redirect_to @post_url }
      format.json { head :no_content }
    end
  end
end
