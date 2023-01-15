class NewsController < ApplicationController
    load_and_authorize_resource
    before_action :set_news, only: [:show, :like, :dislike]

    def index
        @news = News.not_hightlighted
        @hightlighted = News.hightlighted
    end

    def show
        @back_path = news_index_path

        if params['prev'].present? and params['prev'] == 'cosoc'
            @back_path = '/cosoc/noticias'
        end
    end

    def like
        if @news.news_like.where(user_id: current_user.id).exists?
            @news.news_like.find_by(user_id: current_user.id).destroy
        else
            if @news.news_dislike.where(user_id: current_user.id).exists?
                @news.news_dislike.find_by(user_id: current_user.id).destroy
            end

            @news.news_like.create(user_id: current_user.id)
        end
    end

    def dislike
        if @news.news_dislike.where(user_id: current_user.id).exists?
            @news.news_dislike.find_by(user_id: current_user.id).destroy
        else
            if @news.news_like.where(user_id: current_user.id).exists?
                @news.news_like.find_by(user_id: current_user.id).destroy
            end

            @news.news_dislike.create(user_id: current_user.id)
        end
    end

    private
      def set_news
        @news = News.find(params[:id])
      end
end
