class Moderation::EventsController < Moderation::BaseCustomController
  def publish
    event = Event.find(params[:id])
    event.published_at = Time.now
    event.save!

    redirect_to moderation_events_path, notice: '¡El evento ha sido publicado!'
  end

  private
    def send_email_to_author
      false
    end

    def pronoun_vowel
      'o'
    end

    def readable_model
      'evento'
    end

    def resource_model
      Event
    end

    def get_records
      Event.where(published_at: nil)
    end
end
