class GeographicController < ApplicationController
  skip_authorization_check

  def get_street_numbers
    street_name = params[:q]

    results = []

    if street_name.present?
      results = LoBarnecheaApi.new.get_street_numbers(street_name)
    end

    render json: results
  end
end
