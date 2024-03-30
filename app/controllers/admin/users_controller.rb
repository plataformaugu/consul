class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  has_filters %w[active not_validated las_condes erased without_sector], only: :index

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

  def validate
    @user.confirmed_at = Time.now
    @user.save!

    flash[:notice] = "El usuario fue validado correctamente."
    redirect_to admin_users_path(filter: 'not_validated')
  end

  def validate_all
    User.where(confirmed_at: nil).update(confirmed_at: Time.now)

    flash[:notice] = "Los usuarios fueron validados correctamente."
    redirect_to admin_users_path(filter: 'not_validated')
  end

  def validate_multiple
    selected_ids = params['selected_ids']
    User.where(id: selected_ids).update(confirmed_at: Time.now)

    flash[:notice] = "¡Los usuarios fueron validados correctamente!"
    redirect_to admin_users_path(filter: 'not_validated')
  end

  def update_tarjeta_vecino
    is_changed = @user.update_tarjeta_vecino

    if is_changed
      flash[:notice] = "¡Los datos de Tarjeta Vecino se actualizaron correctamente!"
    else
      flash[:alert] = "Los datos de Tarjeta Vecino ya están actualizados."  
    end 
    
    redirect_to admin_users_path(filter: 'las_condes')
  end

  def update_tarjeta_vecino_multiple
    selected_ids = params['selected_ids']
    selected_users = User.where(id: selected_ids)

    selected_users.each do |selected_user|
      selected_user.update_tarjeta_vecino
    end

    flash[:notice] = "La actualización de los datos de Tarjeta Vecino se realizó correctamente."
    redirect_to admin_users_path(filter: 'las_condes')
  end
end
