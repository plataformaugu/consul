class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  has_filters %w[active erased without_sector], only: :index

  def index
    @users = @users.send(@current_filter)
    @users = @users.by_username_email_or_document_number(params[:search]) if params[:search]
    @users = @users.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_user
    if params['user_id'].present?
      @user = User.find_by(id: params['user_id'])
      @sectors = Sector.all
      
      if @user.nil?
        redirect_to admin_users_path(filter: 'without_sector')
      end
    else
      redirect_to admin_users_path(filter: 'without_sector')
    end
  end

  def edit_user_patch
    user = User.find(params['user']['user_id'])
    sector = Sector.find(params['user']['sector_id'])
    user.sector = sector
    user.save!

    redirect_to admin_users_path(filter: 'without_sector')
  end
end
