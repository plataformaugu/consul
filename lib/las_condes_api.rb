module LasCondesAPI
  def send_user_data_to_neighborhood_directory(user, address_id)
    begin
      logger.info("Sending user data to neighborhood directory...")

      uri = URI("https://bus-datos.lascondes.cl/api/maestros/vecinos/")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.read_timeout = 5

      civil_status = 'SOLTERO'

      if user.civil_status
        if user.civil_status == 'C'
          civil_status = 'CASADO'
        elsif user.civil_status == 'V'
          civil_status = 'VIUDO'
        end
      end

      payload = {
        "rut": user.document_number, 
        "nombre": user.first_name,
        "ap_paterno": user.last_name,
        "ap_materno": user.maiden_name,
        "email": user.email,
        "celular": user.phone_number.to_i, 
        "cod_comuna": "13114", 
        "origen": "PARTICIPACION", 
        "sexo": user.gender.upcase, 
        "estado_civil": civil_status, 
        "fc_nacimiento": user.date_of_birth.strftime('%Y-%m-%d'), 
        "id_direccion": address_id
      }

      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
      request.body = JSON.dump(payload)
      response = https.request(request)

      if response.kind_of? Net::HTTPSuccess
        return nil
      else
        raise "API response error: #{response.body}"
      end
    rescue => e
      logger.error("[CUSTOM ERROR] Failed to send user data to neighborhood directory for user #{user.document_number}")
      logger.error e.message
      return nil
    end
  end
end
