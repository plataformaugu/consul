class Admin::SurveyItemsController < Admin::BaseController
  before_action :set_survey_item, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "El elemento fue %{action} correctamente."

  def show
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @survey_item = Survey::Item.new(survey: @survey)
  end

  def edit
    @survey = Survey.find(params[:survey_id])
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_item = Survey::Item.new(
      survey_items_params.merge(
        data: survey_items_params[:data].split(',').map{ |value| value.strip },
        survey_id: @survey.id
      )
    )

    if @survey_item.save
      redirect_to items_admin_survey_path(@survey.id), notice: NOTICE_TEXT % {action: 'creado'}
    else
      render :new
    end
  end

  def update
    if @survey_item.update(
      survey_items_params.merge(
        data: survey_items_params[:data].split(',').map{ |value| value.strip }
      )
    )
      redirect_to items_admin_survey_path(@survey_item.survey.id), notice: NOTICE_TEXT % {action: 'actualizado'}
    else
      render :edit
    end
  end

  def destroy
    @survey_item.destroy
    redirect_to items_admin_survey_path(@survey_item.survey.id), notice: NOTICE_TEXT % {action: 'eliminado'}
  end

  private
    def set_survey_item
      @survey_item = Survey::Item.find(params[:id])
    end

    def survey_items_params
      params.require(:survey_item).permit(:title, :item_type, :data, :position, :required, :survey_id)
    end
end
