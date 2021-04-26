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
    formatted_rut = params['rut'].gsub(/[^a-z0-9]/i, '')

    if User.where(email: params['email']).exists?
      @new_user = User.where(email: params['email'])
    elsif User.where(document_number: formatted_rut).exists?
        @new_user = User.where(document_number: formatted_rut)
    elsif User.where(document_number: formatted_rut.downcase).exists?
        @new_user = User.where(document_number: formatted_rut.downcase)
    elsif User.where(document_number: formatted_rut.upcase).exists?
        @new_user = User.where(document_number: formatted_rut.upcase)
    else
        @new_user = User.where(email: '120391203912039123012931023120', username: 'x@x@x@x@x#x$x%x^x&')
    end

    if @group.users.select {|u| u[:email] == params['email']}.count > 0 or @group.users.select {|u| u[:rut] == formatted_rut}.count > 0
      flash[:alert] = 'El usuario ya es parte del grupo.'
      redirect_to @group
      return
    end

    if @new_user.exists?
      if @new_user.first.is_individual.nil?
        if @group.users.count <= 15
          @group_user = GroupUser.create(name: params['name'], rut: formatted_rut, email: params['email'], group_id: @group.id)
          Mailer.user_invite(params['email']).deliver_later
          flash[:notice] = '%s agregado correctamente al grupo.' % [params['name']]
          redirect_to @group
        else
          flash[:alert] = 'El grupo alcanzó el limite de 15 participantes.'
          redirect_to @group
        end
      else
        if @new_user.first.is_individual == true
          flash[:alert] = 'El usuario está participando individualmente.'
          redirect_to @group
        else
          flash[:alert] = 'El usuario ya está en un grupo.'
          redirect_to @group
        end
      end
    else
      if @group.users.count <= 15
        @group_user = GroupUser.create(name: params['name'], rut: formatted_rut, email: params['email'], group_id: @group.id)
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
    @type = params[:type]
    @user = current_user

    if @type == 'individual'
      @user.is_individual = true
      @user.save
    elsif @type == 'grupal'
      @group = Group.create()
      @group_user = GroupUser.create(name: @user.name, email: @user.email, rut: @user.document_number, group_id: @group.id)
      @user.is_individual = false
      @user.group_id = @group.id
      @user.save
    end

    redirect_to root_path
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
