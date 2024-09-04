class ClaveUnicaController < ApplicationController
  skip_authorization_check

  def new
    state = SecureRandom.hex(16)
    session[:clave_unica_state] = state

    authentication_url = ClaveUnica.new.get_authentication_url(state)

    redirect_to authentication_url
  end
end
