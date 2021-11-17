class LoginController < ApplicationController
  def new
  end
  
  def profile
    @user = User.find_by(name: params[:name])
  end
  
  def update
    User.update(about: params[:about])
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
