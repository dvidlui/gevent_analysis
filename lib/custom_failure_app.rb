class CustomFailureApp < Devise::FailureApp
  def redirect
    store_location!
    message = warden.message || warden_options[:message]
    if message == :timeout
      if params[:controller] == "home"
        redirect_to root_path
      else
        redirect_to authorization_path
      end
    else 
      super
    end
  end
end