class AdminMessagesController < ApplicationController
load_and_authorize_resource

  def index

    @admin_messages = AdminMessage.where(addressed_by_admin: nil).page params[:page]

    @q = User.search(params[:q])
    if params[:as] == 'q'
      @users = @q.result(:distinct => true).page params[:page_2]
    else
      @users = User.page params[:page_2]
    end

    @p = Post.search(params[:q])
    if params[:as] == 'p'
      @posts = @p.result(:distinct => true).page params[:page_3]
    else
      @posts = Post.page params[:page_3]
    end

  end


def show
  @admin_message = AdminMessage.find(params[:id])
end

def mark_resolved
  @admin_message = AdminMessage.find(params[:id])
  @admin_message.addressed_by_admin = true
  @admin_message.save!
  respond_to do |format|
      format.html { redirect_to admin_messages_url }

  end
end


def destroy
    @admin_message = AdminMessage.find(params[:id])
    @admin_message.destroy

    respond_to do |format|
      format.html { redirect_to admin_messages_url }

    end
  end




end