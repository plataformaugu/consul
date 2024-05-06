class Sector < ApplicationRecord
  has_many :users

  has_and_belongs_to_many :segmentations

  def self.get_sector_by_coordinates(latitude, longitude)
    found_sector = nil

    if latitude.present? and longitude.present?
      feature_properties = GeocodingService.get_feature_by_coordinates(
        latitude,
        longitude,
        true
      )
  
      if feature_properties.present?
        found_sector = Sector.find_by(internal_id: feature_properties['ID'])
      end
    end

    return found_sector
  end
end
