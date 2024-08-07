class Moderation::PollsController < Moderation::BaseCustomController
  def publish
    poll = Poll.find(params[:id])
    poll.published_at = Time.now
    poll.save!

    redirect_to moderation_polls_path, notice: '¡La consulta ha sido publicada!'
  end

  private
    def send_email_to_author
      false
    end

    def readable_model
      'consulta'
    end

    def resource_model
      Poll
    end

    def get_records
      Poll.where(published_at: nil)
    end
end
