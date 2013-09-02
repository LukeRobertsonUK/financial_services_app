class AdminMessagesController < ApplicationController


  def index
    @admin_messages = AdminMessage.where(addressed_by_admin: nil)

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