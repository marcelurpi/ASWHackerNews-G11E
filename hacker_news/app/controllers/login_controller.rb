class LoginController < ApplicationController
  def new
  end
  
  def profile
    @user = User.find_by(name: params[:name])
    key   = ActiveSupport::KeyGenerator.new(ENV['SECRET_KEY']).generate_key(ENV['ENCRYPTION_SALT'], ActiveSupport::MessageEncryptor.key_len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    @api_key = crypt.encrypt_and_sign(@user.id)
  end
  
  def usuaris
    p 'entra'
    @usuaris = User.all
    if !params[:usuari_id].nil? && params[:usuari_id]
      p 'primer if'
        @usuaris = User.where(id: params[:usuari_id] )
        if @usuaris.nil?  #si el usuario es null
          respond_to do |format|
          format.html
          format.json { head :bad_request }
          end
          return
        end
    end
    respond_to do |format|
          format.html
          format.json { render json: @usuaris }
    end
  end
  
  def update
    if !params[:id].nil?
      @usuari = User.where(id: params[:id])
      if !@usuari.nil?  #si el usuari existe se updatea
        if !params[:about].nil?
          @usuari.update(about: params[:about])
        end
        if !params[:email].nil?
          @usuari.update(email: params[:email])
        end
      else  #si no existe devuelve bad request
         respond_to do |format|
          format.html
          format.json { head :bad_request}
        end
        return
      end
      respond_to do |format|
          format.html
          format.json {render json: @usuari, head: 201}
        end
      
    else  #si el id no es valido
      respond_to do |format|
          format.html
          format.json { head :bad_request}
        end
    end
  end
  
  def create
    if user = authenticate_with_google
      cookies.signed[:user_id] = user.id
      redirect_to controller: :posts, action: :index
    else
      redirect_to new, alert: 'authentication_failed'
    end
  end
  
  def delete
    cookies.delete :user_id
    redirect_to controller: :posts, action: :index
  end
  
  private
    def authenticate_with_google
      if id_token = flash[:google_sign_in]['id_token']
        identity = GoogleSignIn::Identity.new(id_token)
        user = User.find_by google_id: identity.user_id
        if user
          return user
        else
          return User.create(name: identity.name, email: identity.email_address, google_id: identity.user_id)
        end
      elsif error = flash[:google_sign_in][:error]
        logger.error "Google authentication error: #{error}"
        nil
      end
    end
end
