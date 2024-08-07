class Moderation::NewsController < Moderation::BaseCustomController
  def publish
    news = News.find(params[:id])
    news.published_at = Time.now
    news.save!

    redirect_to moderation_news_index_path, notice: '¡La noticia ha sido publicada!'
  end

  private
    def send_email_to_author
      false
    end

    def readable_model
      'noticia'
    end

    def resource_model
      News
    end

    def get_records
      News.where(published_at: nil)
    end
end
