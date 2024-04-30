class GeographicController < ApplicationController
  skip_authorization_check

  def check_address
    address = params[:q]
    street_name, _, house_number = address.rpartition(' ')

    results = []

    if street_name.present? and house_number.present?
      results = LoBarnecheaApi.new.search_address(street_name, house_number)[..9]
    end

    render json: results
  end
end
