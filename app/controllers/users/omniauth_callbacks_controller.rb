class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def google_oauth2
    if current_user.present?
      Source.from_omniauth(request.env["omniauth.auth"], current_user)
      redirect_to root_path
    end
  end
end