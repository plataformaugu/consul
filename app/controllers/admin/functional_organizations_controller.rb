class Admin::FunctionalOrganizationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_functional_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_layout, only: [:index]

  # GET /popups
  def index
    @functional_organizations = FunctionalOrganization.all
  end

  # POST /popups
  def create
    @functional_organization = FunctionalOrganization.new(functional_organization_params)

    if @functional_organization.save
      redirect_to admin_functional_organizations_path, notice: 'La organización funcional fue creada correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /popups/1
  def update
    if @functional_organization.update(functional_organization_params)
      redirect_to admin_functional_organizations_path, notice: 'La organización funcional fue actualizada correctamente.'
    else
      render :edit
    end
  end

  # DELETE /popups/1
  def destroy
    @functional_organization.destroy
    redirect_to admin_functional_organizations_path, notice: 'La organización funcional fue eliminada.'
  end

  private

    def set_functional_organization
      @functional_organization = FunctionalOrganization.find(params[:id])
    end

    def functional_organization_params
      params.require(:functional_organization).permit(
        :name,
        :conformation_date,
        :president_name,
        :phone_number,
        :email,
        :address,
        :mission,
        :view,
        :whatsapp,
        :twitter,
        :facebook,
        :instagram,
        :url,
        :main_theme_id
      )
    end
end
