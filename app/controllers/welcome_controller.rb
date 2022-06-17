require "#{Rails.root}/lib/tarjeta_vecino_service"

class WelcomeController < ApplicationController
  include TarjetaVecino
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    sign_in(:user, User.first)
    @header = Widget::Card.header.first
    @feeds = Widget::Feed.active
    @cards = Widget::Card.body
    @remote_translations = detect_remote_translations(@feeds,
                                                      @recommended_debates,
                                                      @recommended_proposals)
  end

  def welcome
    redirect_to root_path
  end

  def tarjeta_vecino
    # types
    # 1: No tiene
    # 2: No vigente
    # 3: Si tiene

    @type = nil

    if current_user
      if current_user.has_tarjeta_vecino == false or (current_user.has_tarjeta_vecino and current_user.is_tarjeta_vecino_active == false)
        @type = 1

        if current_user.has_tarjeta_vecino == true and current_user.is_tarjeta_vecino_active == false
          @type = 2
        end
      else
        @type = 3
      end

      render :tarjeta_vecino
    else
      redirect_to root_path
    end
  end

  private

    def set_user_recommendations
      @recommended_debates = Debate.recommendations(current_user).sort_by_recommendations.limit(3)
      @recommended_proposals = Proposal.recommendations(current_user).sort_by_recommendations.limit(3)
    end
end
