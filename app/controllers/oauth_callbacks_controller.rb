class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_callback, only: [:github, :vkontakte]

  def github
  end

  def vkontakte
  end

  private

  def oauth_callback
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: "Something gone wrong, try again"
      return
    end
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session['devise.provider'] = auth.provider
      session['devise.uid'] = auth.uid
      redirect_to new_user_confirmation_path
    end
  end
end
