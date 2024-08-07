class Admin::NewsController < Admin::BaseController
  before_action :set_news, only: [:show, :edit, :update, :destroy, :pending]

  NOTICE_TEXT = "La noticia fue %{action} correctamente."

  def index
    @news = News.all
  end

  def pending; end

  def new
    @news = News.new
  end

  def edit
  end

  def create
    @news = News.new(news_params)

    if @news.save
      if current_user.administrator? and current_user.without_organization?
        @news.published_at = Time.now
        @news.save!
        redirect_to admin_news_index_path, notice: NOTICE_TEXT % {action: 'creada'}
        return
      else
        redirect_to pending_news_path(@news)
        return
      end
    else
      render :new
    end
  end

  def update
    if @news.update(news_params)
      redirect_to admin_news_index_path, notice: NOTICE_TEXT % {action: 'actualizada'}
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to admin_news_index_path, notice: NOTICE_TEXT % {action: 'eliminada'}
  end

  private
    def set_news
      @news = News.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title, :body, :image)
    end
end
