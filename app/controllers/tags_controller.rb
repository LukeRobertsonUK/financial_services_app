class TagsController < ApplicationController
# load_and_authorize_resource
    def index
      @exact_tag = ActsAsTaggableOn::Tag.where(name: "#{params[:q]}").first
      @like_tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%").limit(10)
      results = []
      if @exact_tag
        results << @exact_tag.attributes
      end
      results << @like_tags.map(&:attributes)
      results = results.flatten.compact.uniq
      unless @exact_tag
        results << { "id" => "CREATE_#{params[:q]}_END", "name" => "Add: #{params[:q]}"}
      end
      respond_to do |format|
        format.html
        format.json { render :json => results }
      end
    end

end