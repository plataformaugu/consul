class UsersController < ApplicationController
  load_and_authorize_resource
  helper_method :valid_interests_access?

  def show
    raise CanCan::AccessDenied if params[:filter] == "follows" && !valid_interests_access?(@user)
  end

  def find_user_by_document_number
    organization = params[:organization]

    if organization.present? && User::ORGANIZATIONS_WITHOUT_OTHER.include?(organization)
      found_user = User.select(
        :id,
        :first_name,
        :last_name,
        :document_number,
      ).find_by(
        document_number: params[:document_number].gsub(/[^a-z0-9]+/i, "").upcase,
        organization_name: organization
      )
      data = {
        user: found_user
      }.to_json
    else
      found_user = User.select(
        :id,
        :first_name,
        :last_name,
        :document_number,
      ).find_by(document_number: params[:document_number].gsub(/[^a-z0-9]+/i, "").upcase)
      data = {
        user: found_user
      }.to_json
    end

    render json: data
  end

  private

    def valid_interests_access?(user)
      user.public_interests || user == current_user
    end
end
