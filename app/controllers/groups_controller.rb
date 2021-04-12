class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /groups
  def index
    if current_user
      unless current_user.group_id.nil?
        @group = Group.find(current_user.group_id)
        redirect_to @group
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  # GET /groups/1
  def show
    unless current_user
      redirect_to root_path
    end

    if current_user && current_user.group_id != @group.id
      redirect_to root_path
    end
  end

  # GET /groups/new
  def new
    redirect_to root_path
  end

  # GET /groups/1/edit
  def edit
    unless current_user
      redirect_to root_path
    end

    if current_user.group_id != @group.id
      redirect_to root_path
    end
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if User.where(email: params['email']).exists?
      @new_user = User.where(email: params['email'])
    else
        @new_user = User.where(email: '120391203912039123012931023120', username: 'x@x@x@x@x#x$x%x^x&')
    end

    if @new_user.exists?
      if @group.users.count <= 15
        if @new_user.first.group_id.nil?
          @group_user = GroupUser.create(name: params['name'], email: params['email'], group_id: @group.id)
          Mailer.user_invite(params['email']).deliver_later
          flash[:notice] = '%s agregado correctamente al grupo.' % [params['name']]
          redirect_to @group
        else
          flash[:alert] = 'El usuario ya está en un grupo.'
          redirect_to @group
        end
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

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def set_participation
    @user = current_user

    unless Group.where(user_id: @user.id).exists?
      @group = Group.create(user_id: @user.id)
      @group_user = GroupUser.create(name: @user.name, email: @user.email, rut: @user.document_number, group_id: @group.id)
      @user.group_id = @group.id
      @user.save
    end

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
