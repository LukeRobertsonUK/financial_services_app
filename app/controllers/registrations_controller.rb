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


  # GET /resource/edit
  def edit
    @default = resource.firm ? [resource.firm.name, resource.firm.id] : ["select from list or enter details below", ""]
    @user_written_tags = resource.investment_style_list.reject {|item| User::INVESTMENT_STYLES.values.flatten.include?(item)}


    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update

    account_update_params["investment_style_list"] = (account_update_params["investment_style_list"] << params["extra_tags"].split(", ")).flatten

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end



end