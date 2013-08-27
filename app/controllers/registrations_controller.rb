class RegistrationsController < Devise::RegistrationsController

  # GET /resource/sign_up
  def new
    build_resource({})

    self.resource.firm = Firm.where(id: params[:firm_id]).first || Firm.new
    respond_with self.resource

  end


  # POST /resource
  def create
    existing_firm =  Firm.where({
      name: sign_up_params["firm_attributes"]["name"],
      city: sign_up_params["firm_attributes"]["city"],
      postcode: sign_up_params["firm_attributes"]["postcode"]
    }).first

   if existing_firm
      sign_up_params.delete("firm_attributes")
      build_resource(sign_up_params)
      resource.firm_id = existing_firm.id
   else
      if sign_up_params["firm_attributes"]["name"].blank?
        sign_up_params.delete("firm_attributes")
      end
      build_resource(sign_up_params)
      unless params["organization_id"].blank?
        resource.firm_id = params["organization_id"].to_i unless resource.firm
      end
   end

    if resource.save

      unless resource.firm.editor
        resource.firm.editor = resource
        resource.firm.save!
      end

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
    if self.resource.firm
      @editable = (self.resource.firm.editor == resource)
    else
      @editable = false
    end
    @default = resource.firm ? [resource.firm.name, resource.firm.id] : ["select from list or enter details below", ""]
    @user_written_tags = resource.investment_style_list.reject {|item| User::INVESTMENT_STYLES.values.flatten.include?(item)}
    if self.resource.firm
      self.resource.firm = Firm.new unless @editable
    else
      self.resource.firm = Firm.new
    end
    render :edit
  end



  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    unless params["extra_tags"].blank?
      account_update_params["investment_style_list"] = (account_update_params["investment_style_list"] << params["extra_tags"].split(", ")).flatten
    end

    existing_firm =  Firm.where({
      name: sign_up_params["firm_attributes"]["name"],
      city: sign_up_params["firm_attributes"]["city"],
      postcode: sign_up_params["firm_attributes"]["postcode"]
    }).first
    drop_down_firm = Firm.where(id: params["organization_id"].to_i).first

    unless (params["editing"] && params["editing"] == "true")
      binding.pry
      if account_update_params["firm_attributes"]["name"].blank?
        if drop_down_firm
          account_update_params[:firm_id] = drop_down_firm.id
        end
        account_update_params.delete("firm_attributes")
      else
        if existing_firm
           account_update_params[:firm_id] = existing_firm.id
        end
        new_firm = Firm.new
        new_firm.name = account_update_params["firm_attributes"]["name"]
        new_firm.website = account_update_params["firm_attributes"]["website"]
        new_firm.corporate_disclaimer = account_update_params["firm_attributes"]["corporate_disclaimer"]
        new_firm.building = account_update_params["firm_attributes"]["building"]
        new_firm.street_address = account_update_params["firm_attributes"]["street_address"]
        new_firm.postcode = account_update_params["firm_attributes"]["postcode"]
        new_firm.country = account_update_params["firm_attributes"]["country"]
        new_firm.city = account_update_params["firm_attributes"]["city"]
        new_firm.editor_id = resource.id
        new_firm.save!
        account_update_params.delete("firm_attributes")
        account_update_params[:firm_id] = new_firm.id

      end
    end










    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      unless resource.firm.editor
        resource.firm.editor = resource
        resource.firm.save!
      end

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