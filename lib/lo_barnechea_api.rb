class LoBarnecheaApi
  URL = "https://lbapims.azure-api.net"

  def get_street_names
    street_names = Rails.cache.fetch('street_names', expires_in: 24.hours) do
      fetch_street_names
    end

    if street_names.empty?
      street_names = fetch_street_names
    end

    return street_names
  end

  def get_street_numbers(street_name)
    uri = URI("#{URL}/MaestroCalles/api01/getInfoByCalle?apikey=#{Rails.application.secrets.lo_barnechea_api_key}")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    https.read_timeout = 15

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({"calle": street_name})

    begin
      response = https.request(request)

      if response.kind_of? Net::HTTPSuccess
        parsed_response = JSON.parse(response.body)
        if parsed_response.key?('direcciones')
          return parsed_response['direcciones'].map { |record| record['_source']['numero'] }.uniq
        end
      else
        log_error(
          method: __method__,
          endpoint: uri,
          request_body: { calle: street_name },
          status: response.code,
          response_body: response.body
        )
      end
    rescue StandardError => e
      log_exception(method: __method__, endpoint: uri, exception: e)
    end

    []
  end

  private
    def fetch_street_names
      uri = URI("#{URL}/MaestroCalles/api/getCalles?apikey=#{Rails.application.secrets.lo_barnechea_api_key}")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.read_timeout = 15

      request = Net::HTTP::Post.new(uri)

      begin
        response = https.request(request)

        if response.kind_of? Net::HTTPSuccess
          parsed_response = JSON.parse(response.body)
          if parsed_response.key?('direcciones')
            return parsed_response['direcciones']
          end
        else
          log_error(
            method: __method__,
            endpoint: uri,
            request_body: nil,
            status: response.code,
            response_body: response.body
          )
        end
      rescue StandardError => e
        log_exception(method: __method__, endpoint: uri, exception: e)
      end

      []
    end

    def log_error(method:, endpoint:, request_body:, status:, response_body:)
      Rails.logger.error(
        "[LoBarnecheaApi] Request failed | " \
        "method=#{method} " \
        "endpoint=#{endpoint} " \
        "request_body=#{request_body.inspect} " \
        "status=#{status} " \
        "response_body=#{response_body}"
      )
    end

    def log_exception(method:, endpoint:, exception:)
      Rails.logger.error(
        "[LoBarnecheaApi] Request exception | " \
        "method=#{method} " \
        "endpoint=#{endpoint} " \
        "exception=#{exception.class} " \
        "message=#{exception.message} " \
        "backtrace=#{exception.backtrace&.first(5)&.join(' | ')}"
      )
    end
end
