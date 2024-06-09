class NewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /news
  def index
    @news = Kaminari.paginate_array(News.all.order(created_at: :desc)).page(params[:page])
  end

  # GET /news/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def news_params
      params.require(:news).permit(:title, :body, :image)
    end
end
