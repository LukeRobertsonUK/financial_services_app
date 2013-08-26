class TagsController < ApplicationController

    def index
      @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%")
      results = @tags.map(&:attributes)
      results << { "id" => "CREATE_#{params[:q]}_END", "name" => "Add: #{params[:q]}"}

      respond_to do |format|
        format.html
        format.json { render :json => results }
      end
    end

end