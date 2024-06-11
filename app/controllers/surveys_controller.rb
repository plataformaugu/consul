class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :send_answers]

  load_and_authorize_resource

  # GET /surveys
  def index
    @surveys = Kaminari.paginate_array(Survey.all.order(created_at: :desc)).page(params[:page])
  end

  # GET /surveys/1
  def show
  end

  def send_answers
    # Validar que todos los items estén presentes en los params
    prepared_answers = []

    @survey.items.each do |survey_item|
      current_answer = params["survey_item_#{survey_item.id}"]

      if survey_item.item_type == Survey::Item::ITEM_TYPE_RANKING
        current_answer = current_answer.split(',').map{ |value| value.strip }
      elsif survey_item.required
        if !params.key?("survey_item_#{survey_item.id}")
          flash[:alert] = "Debes completar todos los campos obligatorios."
          render :show
          return
        else
          if current_answer.instance_of?(Array) and current_answer.empty?
            flash[:alert] = "Debes completar todos los campos obligatorios."
            render :show
            return
          elsif current_answer.instance_of?(String) and current_answer.strip.empty?
            flash[:alert] = "Debes completar todos los campos obligatorios."
            render :show
            return
          end
        end
      end

      prepared_answers.push([survey_item.id, current_answer.nil? ? [] : current_answer])
    end

    prepared_answers.each do |prepared_answer|
      Survey::Item::Answer.create(
        survey_item_id: prepared_answer[0],
        data: prepared_answer[1],
        user: current_user
      )
    end

    redirect_to survey_path(@survey.id), notice: "Las respuestas se registraron correctamente."
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
end
