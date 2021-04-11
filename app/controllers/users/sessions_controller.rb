class Users::SessionsController < Devise::SessionsController
  def destroy
    @stored_location = stored_location_for(:user)
    super
  end

  private

    def after_sign_in_path_for(resource)
      process_user_group(resource)

      if !verifying_via_email? && resource.show_welcome_screen?
        root_path
      else
        super
      end
    end

    def process_user_group(resource)
      if resource.is_individual.nil?
        if GroupUser.where(email: resource.email).exists?
          group_user = GroupUser.where(email: resource.email).first
          resource.is_individual = false
          resource.group_id = group_user.group_id
          resource.save
        elsif GroupUser.where(rut: resource.document_number).exists?
          group_user = GroupUser.where(rut: resource.document_number).first
          resource.is_individual = false
          resource.group_id = group_user.group_id
          resource.save
        elsif GroupUser.where(rut: resource.document_number.downcase).exists?
          group_user = GroupUser.where(rut: resource.document_number.downcase).first
          resource.is_individual = false
          resource.group_id = group_user.group_id
          resource.save
        elsif GroupUser.where(rut: resource.document_number.upcase).exists?
          group_user = GroupUser.where(rut: resource.document_number.downcase).first
          resource.is_individual = false
          resource.group_id = group_user.group_id
          resource.save
        end
      end
    end

    def after_sign_out_path_for(resource)
      @stored_location.present? && !@stored_location.match("management") ? @stored_location : super
    end

    def verifying_via_email?
      return false if resource.blank?

      stored_path = session[stored_location_key_for(resource)] || ""
      stored_path[0..5] == "/email"
    end
end
