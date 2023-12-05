class Proposals::FormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper
  attr_reader :proposal, :url
  delegate :current_user, :suggest_data, :geozone_select_options, to: :helpers

  def initialize(proposal, proposal_topic, url, is_municipal = false, lat = nil, lng = nil)
    @proposal = proposal
    @proposal_topic = proposal_topic
    @url = url
    @is_municipal = is_municipal
    @lat = lat
    @lng = lng
  end

  private

    def categories
      Tag.category.order(:name)
    end
end
