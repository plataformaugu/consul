class ClaveUnica
  AUTHENTICATION_URL = 'https://accounts.claveunica.gob.cl/openid/authorize'
  TOKEN_URL = 'https://accounts.claveunica.gob.cl/openid/token/'
  REDIRECT_URI = 'https://participaciongoreantofagasta.gob.cl/clave-unica/get'
  USER_INFO_URL = 'https://accounts.claveunica.gob.cl/openid/userinfo/'

  CLIENT_ID = Rails.application.secrets.clave_unica_client_id
  CLIENT_SECRET = Rails.application.secrets.clave_unica_client_secret

  def get_authentication_url(user)
    response_type = 'code'
    scope = 'openid run name'
    user_token = user.generate_token
    authentication_url = "#{AUTHENTICATION_URL}/?client_id=#{CLIENT_ID}&response_type=#{response_type}&scope=#{scope}&redirect_uri=#{REDIRECT_URI}&state=#{user_token}"

    return authentication_url
  end

  def get_access_token(user, code)
    user_token = user.generate_token

    url = URI(TOKEN_URL)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['charset'] = 'UTF-8'
    request.body = "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=#{REDIRECT_URI}&grant_type=authorization_code&code=#{code}&state=#{user_token}"
  
    response = https.request(request)
    result = JSON.parse(response.body)

    return result['access_token']
  end

  def get_user_information(access_token)
    url = URI("https://accounts.claveunica.gob.cl/openid/userinfo/")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Bearer #{access_token}"

    response = https.request(request)
    result = JSON.parse(response.body)
    
    return result
  end
end
