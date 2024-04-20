class LoBarnecheaApi
  URL = "https://integrador.lobarnechea.cl:8443"

  def search_address(street, house_number)
    uri = URI("#{URL}/api/direcciones")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.read_timeout = 15

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request["apikey"] = Rails.application.secrets.lo_barnechea_api_key
    request.body = JSON.dump({
      "query": {
        "bool": {
          "should": [
              {
                "match_phrase": {
                    "calle": street
                }
              },
              {
                "wildcard": {
                  "numero": {
                    "value": house_number,
                    "boost": "2.0",
                    "rewrite": "constant_score"
                  }
                }
              }
          ],
          "must_not": []
        }
      }
    })
    response = https.request(request)

    results = []

    if response.kind_of? Net::HTTPSuccess
      parsed_response = JSON.parse(response.body)

      if parsed_response.key?('hits') && !parsed_response.key?('message')
        results = parsed_response['hits']['hits'][0].map {
          |x| [x['_source']['calle'], x['_source']['numero']]
        }
      end
    end

    return results
  end
end
