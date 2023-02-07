class Admin::NewsController < ApplicationController
    layout 'admin'
    before_action :authenticate_user!
    load_and_authorize_resource
    before_action :set_news, only: [:show, :edit, :update, :destroy]
    before_action :set_layout, only: [:index]
  
    def index
      if not current_user.administrator?
        redirect_to root_path
      end

      @news = News.all
      @hightlighted = News.hightlighted
    end

    def new
      @news = News.new
    end

    def create
      @news = News.new(news_params)

      if params['news']['is_hightlighted'] == '1' 
        if params['news']['highlight_until_days'].present? and (Integer(params['news']['highlight_until_days']) rescue false)
          highlight_until_days = params['news']['highlight_until_days'].to_i

          if 1 >= highlight_until_days or highlight_until_days <= 365
            @news.highlight_until = Date.current + highlight_until_days
          end
        end
      else
        @news.highlight_until = nil
      end
  
      if @news.save
        redirect_to admin_news_index_path, notice: 'La noticia fue creada correctamente.'
      else
        render :new
      end
    end
  
    def update
      if params['news']['is_hightlighted'] == '1' 
        if params['news']['highlight_until_days'].present? and (Integer(params['news']['highlight_until_days']) rescue false)
          highlight_until_days = params['news']['highlight_until_days'].to_i

          if 1 >= highlight_until_days or highlight_until_days <= 365
            @news.highlight_until = Date.current + highlight_until_days
          end
        end
      else
        @news.highlight_until = nil
      end

      if @news.update(news_params)
        redirect_to admin_news_index_path, notice: 'La noticia fue actualizada correctamente.'
      else
        render :edit
      end
    end
  
    def destroy
      @news.destroy
      redirect_to admin_news_index_path, notice: 'La noticia fue eliminada.'
    end
  
    private
      def set_news
        @news = News.find(params[:id])
      end
  
      def news_params
        params.require(:news).permit(:title, :body, :image, :main_theme, :highlight_until, :main_theme_id, :news_type, :summary, :miniature, :neighborhood_council_id)
      end
  end
  