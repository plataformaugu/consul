class Admin::ProposalTopicsController < Admin::BaseController
  before_action :set_proposal_topic, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "La convocatoria fue %{action} correctamente."

  def pending; end

  def index
    @proposal_topics = ProposalTopic.all

    if !current_user.without_organization?
      @proposal_topics = ProposalTopic.where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      )
    end
  end

  def new
    @proposal_topic = ProposalTopic.new
  end

  def edit
  end

  def create
    @proposal_topic = ProposalTopic.new(proposal_topic_params)
    @proposal_topic.image.attach(
      io: resize_image(proposal_topic_params[:image].tempfile.path),
      filename: proposal_topic_params[:image].original_filename,
      content_type: proposal_topic_params[:image].content_type
    )

    if @proposal_topic.save
      if current_user.administrator? and current_user.without_organization?
        @proposal_topic.published_at = Time.now
        @proposal_topic.save!
        redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'creada'}
        return
      else
        redirect_to pending_proposal_topic_path(@proposal_topic)
        return
      end
    else
      render :new
    end
  end

  def update
    if @proposal_topic.update(proposal_topic_params)
      if proposal_topic_params[:image].present?
        @proposal_topic.image.purge
        @proposal_topic.image.attach(
          io: resize_image(proposal_topic_params[:image].tempfile.path),
          filename: proposal_topic_params[:image].original_filename,
          content_type: proposal_topic_params[:image].content_type
        )
        @proposal_topic.save
      end

      redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'actualizada'}
    else
      render :edit
    end
  end

  def destroy
    @proposal_topic.image.purge
    @proposal_topic.destroy
    redirect_to admin_proposal_topics_path, notice: NOTICE_TEXT % {action: 'eliminada'}
  end

  private
    def set_proposal_topic
      @proposal_topic = ProposalTopic.find(params[:id])
    end

    def proposal_topic_params
      params.require(:proposal_topic).permit(:title, :description, :image, :start_date, :end_date, organizations: [])
    end

    def resize_image(temp_path)
      image = ImageProcessing::MiniMagick.source(temp_path).resize_to_limit!(800, nil)
      return image
    end
end
