class RegistrationsController < Devise::RegistrationsController

  # GET /resource/sign_up
  def new
    build_resource({})

    self.resource.firm = Firm.where(id: params[:firm_id]).first || Firm.new
    respond_with self.resource

  end


  # POST /resource
  def create
    if sign_up_params["firm_attributes"]["name"].blank?
      sign_up_params.delete("firm_attributes")
    end

    build_resource(sign_up_params)

    unless params["organization_id"].blank?
      unless sign_up_params["firm_attributes"]
        resource.firm_id = params["organization_id"].to_i
      end
    end

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end