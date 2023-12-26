class SocialOrganizationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /social_organizations
  def index
    redirect_to new_social_organization_path
  end

  # GET /social_organizations/new
  def new
    @social_organization = SocialOrganization.new
  end

  # POST /social_organizations
  def create
    @social_organization = SocialOrganization.new(social_organization_params)
    @social_organization.name = @social_organization.name.gsub(';', '')
    @social_organization.description = @social_organization.description.gsub(';', '')

    if @social_organization.save
      redirect_to new_social_organization_path, notice: 'La Organización Social fue enviada.'
    else
      render :new
    end
  end

  private
    def social_organization_params
      params.require(:social_organization).permit(:name, :description, :email, :url, :user_id)
    end
end
