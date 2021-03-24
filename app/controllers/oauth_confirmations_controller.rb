class OauthConfirmationsController < Devise::ConfirmatinsController
  def create
    @email = confirm_params[:email]
    password = Devise.friendly_token[0,20]
    @user = User.new(email: @email,
                 password: password,
                 password_confirmation: password)

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
end