class UsersController < ApplicationController
  load_and_authorize_resource
  helper_method :valid_interests_access?

  def show
    raise CanCan::AccessDenied if params[:filter] == "follows" && !valid_interests_access?(@user)
  end

  def login
    if request.post?
      @key = 'c82161e4d7547dbfaa1249203fd3d8e9'
      @state = SecureRandom.hex
      @clave_unica_url = "https://claveunica.lascondes.cl/clave-unica/#{@key}/#{@state}"

      redirect_to @clave_unica_url
    end
  end

  private

    def valid_interests_access?(user)
      user.public_interests || user == current_user
    end
end
