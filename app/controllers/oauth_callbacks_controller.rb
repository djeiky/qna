class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    oauth_callback('github')
  end

  private
  def oauth_callback(provider)
    @user = User.find_for_auth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user , event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session['devise.provider'] = auth.provider
      session['devise.uid'] = auth.uid
      redirect_to new_user_confirmational_path
    end
  end
end
