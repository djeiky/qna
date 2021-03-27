class OauthConfirmationsController < Devise::ConfirmationsController
  def create
    @email = confirm_params[:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email,
                     password: password,
                     password_confirmation: password)

    puts User.all

    if @user.save!
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'Enter valid email!!'
      render :new
    end
  end

  private

  def confirm_params
    params.permit(:email)
  end

  def auth
    @auth ||= {provider: session['devise.provider'], uid: session['devise.uid']}
  end

  def after_confirmation_path_for(resource_name, user)
    user.authorizations.create(auth)
    sign_in user, event: :authentication
    signed_in_root_path user
  end
end