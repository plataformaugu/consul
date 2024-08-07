class Moderation::SurveysController < Moderation::BaseCustomController
  def publish
    survey = Survey.find(params[:id])
    survey.published_at = Time.now
    survey.save!

    redirect_to moderation_surveys_path, notice: '¡La encuesta ha sido publicada!'
  end

  private
    def send_email_to_author
      false
    end

    def readable_model
      'encuesta'
    end

    def resource_model
      Survey
    end

    def get_records
      Survey.where(published_at: nil)
    end
end
