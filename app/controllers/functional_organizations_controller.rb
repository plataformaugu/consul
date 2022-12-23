class FunctionalOrganizationsController < ApplicationController
  before_action :set_functional_organization, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /functional_organizations/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_functional_organization
      @functional_organization = FunctionalOrganization.find(params[:id])
    end
end
