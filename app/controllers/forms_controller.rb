class FormsController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check
  before_action :set_form, only: [:show, :edit, :update, :destroy]

  # GET /forms
  def index
    redirect_to root_path
  end

  # GET /forms/1
  def show
    redirect_to root_path
  end

  # GET /forms/new
  def new
    if current_user && Form.where(user_id: current_user.id).exists?
      render :template => 'forms/form_ready'
    end

    @form = Form.new
  end

  # GET /forms/1/edit
  def edit
    redirect_to root_path
  end

  # POST /forms
  def create
    if Form.where(user_id: current_user.id).exists?
      render :template => 'forms/form_ready'
    end

    @form = Form.new(form_params)

    if params['q21']
      @form.q21 = params['q21'].join(' - ')
    else
      @form.q21 = ''
    end

    if params['q22']
      @form.q22 = params['q22'].join(' - ')
    else
      @form.q22 = ''
    end

    if params['q23']
      @form.q23 = params['q23'].join(' - ')
    else
      @form.q23 = ''
    end

    @form.user_id = current_user.id

    if @form.save
      redirect_to "/users/edit"
    else
      render :new
    end
  end

  # PATCH/PUT /forms/1
  def update
    redirect_to root_path
  end

  # DELETE /forms/1
  def destroy
    if current_user.admin?
      @form.destroy
      redirect_to forms_url, notice: 'Form was successfully destroyed.'
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params.require(:form).permit(:q1, :q1o, :q21, :q21o, :q22, :q22o, :q23, :q23o, :q3, :q41, :q42, :q43, :q5)
    end
end
