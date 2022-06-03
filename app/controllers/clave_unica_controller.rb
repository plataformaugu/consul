class ClaveUnicaController < ApplicationController
    skip_authorization_check

    def get
        @secret = 'aa96dc505cb770099c61a15c34fbb85b'
        @code = params['codigo']
        result = clave_unica_request

        found_user = User.where(document_number: result['rut'].gsub(/[^0-9a-z ]/i, '')).first

        if found_user.present?
            sign_in(:user, found_user)
            redirect_to root_path
        else
            redirect_to new_user_registration_path(type: 'pre')
        end
    end

    def clave_unica_request
        uri = URI('https://claveunica.lascondes.cl/clave-unica/auth-info')
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        request.body = {code: @code, secret: @secret}.to_json
        response = https.request(request)
        result = JSON.parse(response.body)

        return result
    end
end
