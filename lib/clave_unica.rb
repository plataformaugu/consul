class ClaveUnica
  AUTHENTICATION_URL = 'https://accounts.claveunica.gob.cl/openid/authorize'
  TOKEN_URL = 'https://accounts.claveunica.gob.cl/openid/token/'
  REDIRECT_URI = 'https://tudecides.lobarnechea.cl/clave-unica/get'
  USER_INFO_URL = 'https://accounts.claveunica.gob.cl/openid/userinfo/'

  CLIENT_ID = Rails.application.secrets.clave_unica_client_id
  CLIENT_SECRET = Rails.application.secrets.clave_unica_client_secret

  def get_authentication_url(state)
    response_type = 'code'
    scope = 'openid run name'
    redirect_uri = ERB::Util.url_encode(REDIRECT_URI)
    authentication_url = "#{AUTHENTICATION_URL}/?client_id=#{CLIENT_ID}&response_type=#{response_type}&scope=#{scope}&redirect_uri=#{redirect_uri}&state=#{state}"

    return authentication_url
  end

  def get_access_token(state, code)
    begin
      url = URI(TOKEN_URL)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request['charset'] = 'UTF-8'
      request.body = "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=#{REDIRECT_URI}&grant_type=authorization_code&code=#{code}&state=#{state}"
    
      response = https.request(request)
      result = JSON.parse(response.body)

      return result['access_token']
    rescue => e
      logger.error("[CLAVE UNICA] #{e.message}")
      return nil
    end
  end

  def get_user_information(access_token)
    begin
      url = URI(USER_INFO_URL)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Authorization"] = "Bearer #{access_token}"

      response = https.request(request)
      result = JSON.parse(response.body)
      
      return result
    rescue => e
      logger.error("[CLAVE UNICA] #{e.message}")
      return nil
    end
  end
end
