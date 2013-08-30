class PostsController < ApplicationController
load_and_authorize_resource

  # GET /posts
  # GET /posts.json
  def index
    @user_posts = Post.where(user_id:current_user.id)
    @friends_posts = current_user.friends_visible_posts
    @post = Post.new



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json {render :json => @tags.map(&:attributes)}
    end
 end


  def mark_inappropriate
    @post = Post.find(params[:id])
    @post.mark_as_inappropriate_by(current_user)
    redirect_to post_path(@post)
  end


  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @user_posts = Post.where(user_id:current_user.id)

    respond_to do |format|
      if @post.save
        format.js {
           @post= Post.new
        }
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.js
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
