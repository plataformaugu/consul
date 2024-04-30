class GeocodingApi
  BASE_URL = 'https://nominatim.openstreetmap.org/search?'

  def get_coordinates(street_name, house_number)
    fixed_street_name = street_name.gsub('AV.', '').strip()
    street_param = "#{house_number} #{fixed_street_name}"
    url = URI("#{BASE_URL}street=#{street_param}&limit=1&format=json&addressdetails=1&country=Chile&city=Lo Barnechea")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.read_timeout = 10

    coordinates = {
      "latitude" => nil,
      "longitude" => nil
    }

    begin
      request = Net::HTTP::Get.new(url)
      response = https.request(request)
  
      if response.kind_of? Net::HTTPSuccess
        parsed_response = JSON.parse(response.body)
  
        if !parsed_response.empty?
          coordinates["latitude"] = parsed_response[0]['lat'].to_f
          coordinates["longitude"] = parsed_response[0]['lon'].to_f
        end
      end
    rescue => e
      Rails.logger.error("[GEOCODING API] Failed to get coordinates")
      Rails.logger.error e.message
    end

    return coordinates
  end
end
