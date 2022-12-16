class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @slider_elements = [
      {
        image_url: 'https://via.placeholder.com/800x600',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
      {
        image_url: 'https://via.placeholder.com/800x600',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
    ]
    @cards_elements = [
      {
        title: 'Título de prueba 1',
        description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
        image: 'https://via.placeholder.com/800',
        supertitle: 'Debates',
      },
      {
        title: 'Título de prueba 2',
        description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
        image: 'https://via.placeholder.com/600x900',
        supertitle: 'Propuestas Ciudadanas',
      },
      {
        title: 'Título de prueba 3',
        description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
        image: 'https://via.placeholder.com/500',
        supertitle: 'Consultas',
      },
      {
        title: 'Título de prueba 4',
        description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
        image: 'https://via.placeholder.com/1200',
        supertitle: 'Presupuestos participativos',
      },
    ]
  end

  def welcome
    redirect_to root_path
  end

  private

    def set_user_recommendations
      @recommended_debates = Debate.recommendations(current_user).sort_by_recommendations.limit(3)
      @recommended_proposals = Proposal.recommendations(current_user).sort_by_recommendations.limit(3)
    end
end
