require 'net/http'
require 'uri'
require 'json'

class CensoRemoto
  def verificar(document_number)
    if Setting["feature.remote_census"].present?
      begin
        # Nombre del documento para enviar en la petición
        params = {'document_number': document_number}
        url = URI.parse(Setting["remote_census.general.endpoint"])
        http = Net::HTTP.new(url.host, url.port)
        content = { document_number: document_number }

        request = Net::HTTP::Post.new(url.path)
        request.body = JSON.dump(content)
        request.set_content_type("application/json")
        response = http.request(request)
        response_hash = {
          "code" => response.code,
          "body" => response.body
        }
        return response_hash
      rescue
        return false
      end
    end
  end
end