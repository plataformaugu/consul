class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :pending, :send_answers, :participate_manager_form, :participate_manager_existing_user, :participate_manager_new_user]

  load_and_authorize_resource

  def pending; end

  # GET /surveys
  def index
    @surveys = Kaminari.paginate_array(Survey.published.all.order(created_at: :desc)).page(params[:page])
  end

  # GET /surveys/1
  def show
    if current_user.present? && !current_user.without_organization? && !@survey.organizations.include?(current_user.organization_name)
      redirect_to root_path, alert: "No tienes permiso para ver esta página"
    end
  end

  def send_answers
    prepared_answers = get_prepared_answers(@survey, params)

    if prepared_answers.nil?
      flash[:alert] = "Debes completar todos los campos obligatorios."
      render :show
      return
    end

    if params.has_key?(:manager_confirm)
      @prepared_answers = prepared_answers
      render :participate_manager_form
      return
    end

    save_answers(prepared_answers, current_user)

    redirect_to survey_path(@survey.id), notice: "Las respuestas se registraron correctamente."
  end

  def participate_manager_form
  end

  def participate_manager_existing_user
    prepared_answers = JSON.parse(params[:prepared_answers])
    user_id = params[:user_id]

    if user_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Vuelve a intentarlo."
      redirect_to survey_path(@survey.id)
      return
    end

    existing_user = User.find(user_id)

    if @survey.answered_by_user?(existing_user)
      flash[:error] = "Este usuario ya respondió la encuesta."
      redirect_to survey_path(@survey.id)
      return
    end

    save_answers(prepared_answers, existing_user)

    flash[:notice] = "Se respondió la encuesta en nombre de: #{existing_user.full_name}"
    redirect_to survey_path(@survey.id)
  end

  def participate_manager_new_user
    prepared_answers = JSON.parse(params[:user][:prepared_answers])
    clean_document_number = params[:user][:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if User.exists?(document_number: clean_document_number)
      flash[:error] = "Ya existe un usuario registrado con el RUT: #{clean_document_number}."
      redirect_to survey_path(@survey.id)
      return
    end

    if !params[:user][:email].empty? and User.exists?(email: params[:user][:email])
      flash[:error] = "Ya existe un usuario registrado con el email: #{params[:user][:email]}"
      redirect_to survey_path(@survey.id)
      return
    end

    permitted_params = params.require(:user).permit(
      :first_name,
      :last_name,
      :document_number,
      :email,
      :gender,
      :date_of_birth,
      :phone_number,
      :organization_name,
    ).merge(
      document_number: clean_document_number,
      email: params[:user][:email].empty? ? "manager_user_#{clean_document_number}@ugu.cl" : params[:user][:email],
      organization_name: params[:user].has_key?(:organization_name) ? params[:user][:organization_name] : current_user.organization_name
    )

    new_user = User.new(permitted_params)

    new_user.save(validate: false)

    save_answers(prepared_answers, new_user)

    flash[:notice] = "Se respondió la encuesta en nombre de: #{new_user.full_name}"
    redirect_to survey_path(@survey.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(:title, :body, :image)
    end

    def get_prepared_answers(survey, params)
      prepared_answers = []

      survey.items.each do |survey_item|
        current_answer = params["survey_item_#{survey_item.id}"]
  
        if survey_item.item_type == Survey::Item::ITEM_TYPE_RANKING
          current_answer = current_answer.split(',').map{ |value| value.strip }
        elsif survey_item.required
          if !params.key?("survey_item_#{survey_item.id}")
            return nil
          else
            if current_answer.instance_of?(Array) and current_answer.empty?
              return nil
            elsif current_answer.instance_of?(String) and current_answer.strip.empty?
              return nil
            end
          end
        end
  
        prepared_answers.push([survey_item.id, current_answer.nil? ? [] : current_answer])
      end

      return prepared_answers
    end

    def save_answers(prepared_answers, user)
      prepared_answers.each do |prepared_answer|
        Survey::Item::Answer.create(
          survey_item_id: prepared_answer[0],
          data: prepared_answer[1],
          user: user
        )
      end
    end
end
