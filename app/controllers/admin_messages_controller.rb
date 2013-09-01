class AdminMessagesController < ApplicationController


  def index
    @admin_messages = AdminMessage.all


  end


def show
  @admin_message = AdminMessage.find(params[:id])
end



end