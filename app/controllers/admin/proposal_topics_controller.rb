class Admin::ProposalTopicsController < Admin::BaseController
  before_action :set_proposal_topic, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "La convocatoria fue %{action} correctamente."

  def index
    @proposal_topics = ProposalTopic.all
  end

  def new
    @proposal_topic = ProposalTopic.new
  end

  def edit
  end

  def create
    @proposal_topic = ProposalTopic.new(proposal_topic_params)

    if @proposal_topic.save
      redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'creado'}
    else
      render :new
    end
  end

  def update
    if @proposal_topic.update(proposal_topic_params)
      redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'actualizado'}
    else
      render :edit
    end
  end

  def destroy
    @proposal_topic.destroy
    redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'eliminado'}
  end

  private
    def set_proposal_topic
      @proposal_topic = ProposalTopic.find(params[:id])
    end

    def proposal_topic_params
      params.require(:proposal_topic).permit(:title, :description, :image, :start_date, :end_date)
    end
end
