class LoBarnecheaApi
  URL = "https://integrador.lobarnechea.cl:8443"

  def get_street_names
    street_names = Rails.cache.fetch('street_names', expires_in: 24.hours) do
      results = fetch_street_names
    end

    if street_names.empty?
      street_names = fetch_street_names
    end

    return street_names
  end

  def get_street_numbers(street_name)
    uri = URI("#{URL}/prd/api/v1/maestrocalles/detalle/calles/")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.read_timeout = 15

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request["apikey"] = Rails.application.secrets.lo_barnechea_api_key
    request.body = JSON.dump({"calle": street_name})

    response = https.request(request)
    results = []

    if response.kind_of? Net::HTTPSuccess
      parsed_response = JSON.parse(response.body)

      if parsed_response.key?('direcciones')
        results = parsed_response['direcciones'].map { |record| record['_source']['numero'] }.uniq
      end
    end

    return results
  end

  private
    def fetch_street_names
      uri = URI("#{URL}/prd/api/v1/maestrocalles/calles")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.read_timeout = 15

      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request["apikey"] = Rails.application.secrets.lo_barnechea_api_key

      response = https.request(request)
      results = []

      if response.kind_of? Net::HTTPSuccess
        parsed_response = JSON.parse(response.body)

        if parsed_response.key?('direcciones')
          results = parsed_response['direcciones']
        end
      end

      return results
    end
end
