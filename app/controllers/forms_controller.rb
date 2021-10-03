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

    if params['q1']
      @form.q1 = params['q1'].join(' - ')
    else
      @form.q1 = ''
    end

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

    if params['q32']
      @form.q32 = params['q32'].join(' - ')
    else
      @form.q32 = ''
    end

    if params['q34']
      @form.q34 = params['q34'].join(' - ')
    else
      @form.q34 = ''
    end

    @form.user_id = current_user.id

    user_params = params.select { |key, value| key.start_with?('user')}
    current_user.update_attributes(
      custom_age: user_params['user_age'],
      gender: user_params['user_gender'],
      nationality: user_params['user_nationality'],
      region: user_params['user_region'],
      education: user_params['user_education'],
      disability: user_params['user_disability'],
      indigenous: user_params['user_indigenous'],
    )

    if !Form.where(user_id: current_user.id).exists?
      if @form.save
        render :template => 'forms/form_finish'
      else
        render :new
      end
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
      params.require(:form).permit(:q1, :q1o, :q21, :q21o, :q22, :q22o, :q23, :q23o, :q31, :q32, :q32o, :q33, :q34, :q34o, :q4)
    end
end
