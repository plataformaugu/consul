class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /groups
  def index
    unless current_user
      redirect_to root_path
    end
  end

  # GET /groups/1
  def show
    unless current_user
      redirect_to root_path
    else
      unless GroupUser.where(group_id: @group.id).where(email: current_user.email).exists?
        redirect_to root_path
      end
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    unless current_user
      redirect_to root_path
    else
      unless @group.user_id == current_user.id
        redirect_to root_path
      end
    end
  end

  # POST /groups
  def create
    @user = current_user
    @group = Group.create(user_id: @user.id, name: group_params['name'], description: group_params['description'])
    @group_user = GroupUser.create(name: @user.name, email: @user.email, rut: @user.document_number, group_id: @group.id)

    flash[:notice] = 'Grupo creado correctamente.'
    redirect_to @group
  end

  # PATCH/PUT /groups/1
  def update
    if params.key?('is_group_edit') and params['is_group_edit'] == 'true'
      @group.name = group_params['name']
      @group.description = group_params['description']
      @group.save
      flash[:notice] = 'El grupo ha sido modificado correctamente.'
      redirect_to @group
    else
      if User.where(email: params['email']).exists?
        @new_user = User.where(email: params['email'])
      else
        @new_user = User.where(email: '120391203912039123012931023120', username: 'x@x@x@x@x#x$x%x^x&')
      end

      if @new_user.exists?
        if @group.users.count <= 15
          @group_user = GroupUser.create(name: params['name'], email: params['email'], group_id: @group.id)
          Mailer.user_invite(params['email']).deliver_later
          flash[:notice] = '%s agregado correctamente al grupo.' % [params['name']]
          redirect_to @group
        else
          flash[:alert] = 'El grupo alcanzó el limite de 15 participantes.'
          redirect_to @group
        end
      else
        if @group.users.count <= 15
          @group_user = GroupUser.create(name: params['name'], email: params['email'], group_id: @group.id)
          Mailer.user_invite(params['email']).deliver_later
          flash[:notice] = '%s agregado correctamente al grupo.' % [params['name']]
          redirect_to @group
        else
          flash[:alert] = 'El grupo alcanzó el limite de 15 participantes.'
          redirect_to @group
        end
      end
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def set_participation
    @user = current_user
    count = Group.where(user_id: @user.id).count + 1
    @group = Group.create(user_id: @user.id, name: 'Mi grupo #%s' % [count])
    @group_user = GroupUser.create(name: @user.name, email: @user.email, rut: @user.document_number, group_id: @group.id)
    @user.group_id = @group.id
    @user.save

    flash[:notice] = 'Grupo creado correctamente.'
    redirect_to groups_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :description)
    end
end
