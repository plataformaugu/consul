class Admin::SocialOrganizationsController < Admin::BaseController
  before_action :set_social_organization, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "La Organización Social fue %{action} correctamente."

  def index
    @social_organizations = SocialOrganization.all
  end

  def new
    @social_organization = SocialOrganization.new
  end

  def edit
  end

  def create
    @social_organization = SocialOrganization.new(event_params)

    if @social_organization.save
      redirect_to admin_social_organizations_path, notice: NOTICE_TEXT % {action: 'creada'}
    else
      render :social_organization
    end
  end

  def update
    if @social_organization.update(event_params)
      redirect_to admin_social_organizations_path, notice: NOTICE_TEXT % {action: 'actualizada'}
    else
      render :edit
    end
  end

  def destroy
    @social_organization.destroy
    redirect_to admin_social_organizations_path, notice: NOTICE_TEXT % {action: 'eliminada'}
  end

  def generate_csv
    if SocialOrganization.all.any?
      csv = SocialOrganization.to_csv
      puts csv
      send_data(csv, type: 'text/csv', filename: "organizaciones_sociales_#{Time.now.strftime('%Y%m%d_%H%M')}.csv")
    end
  end

  private
    def set_social_organization
      @social_organization = SocialOrganization.find(params[:id])
    end

    def event_params
      params.require(:social_organization).permit(:name, :description, :email, :url, :user_id)
    end
end
