class Proposals::FormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper
  attr_reader :proposal, :url
  delegate :current_user, :suggest_data, :geozone_select_options, to: :helpers

  def initialize(proposal, is_initiative, url:)
    @proposal = proposal
    @url = url
    @is_initiative = is_initiative
  end

  private

    def categories
      Tag.category.order(:name)
    end
end
