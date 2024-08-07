class Moderation::ProposalTopicsController < Moderation::BaseCustomController
  def publish
    proposal_topic = ProposalTopic.find(params[:id])
    proposal_topic.published_at = Time.now
    proposal_topic.save!

    redirect_to moderation_proposal_topics_path, notice: '¡La convocatoria ha sido publicada!'
  end

  private
    def send_email_to_author
      false
    end

    def readable_model
      'convocatoria'
    end

    def resource_model
      ProposalTopic
    end

    def get_records
      ProposalTopic.where(published_at: nil)
    end
end
