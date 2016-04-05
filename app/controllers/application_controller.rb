class ApplicationController < ActionController::Base

  before_action :initialize_omniauth_state
   
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :ajax_url_suffix, :dev?, :prod?, :stage?, :test?

  def dev?; Rails.env == "development"; end
  def prod?; Rails.env == "production"; end
  def stage?; Rails.env == "staging"; end
  def test?; Rails.new == "test"; end

  # Autentication methods
  #----------------------------------------------------------------------
  # Public: Check if the user has his own profile or not
  NEW_USER = "?type=new_user"

  # Public: Check if the user is right user
  def authenticate_verify_user
    if !current_user.present?
      redirect_to request.referrer
    elsif !current_user.has_profile?
      redirect_to profile_dashboard_users_path + NEW_USER
    else
      return true
    end
  end

  alias_method :devise_current_user, :current_user

  # Public: Get current user if user signed in REDIS
  # Returns boolean or redirect user to other pages
  # def current_user
  #   p ">>>>>>>>>>>>>>>>>>>> current_user START >>>>>>>>>>>>>>>>>>>>>>"
  #   p "Cookie: #{get_cookie}"
  #   p ">>>>>>>>>>>>>>>>>>>> current_user END   >>>>>>>>>>>>>>>>>>>>>"
  #   sign_out(:user) unless devise_current_user.nil?
  #   delete_cookie
  #   devise_current_user
  # end

  # Utility methods
  #----------------------------------------------------------------------
  def ajax_url_suffix
    "?type=ajax"
  end

  def to_b(string)
    string == "true"
  end

  # Cookie methods
  #----------------------------------------------------------------------
  # Get cookie(email)
  def get_cookie
    cookies[GeventAnalysis::Application::CONSTS[:cookie_name]]
  end

  # Set cookie(email) with expire time
  def set_cookie(email=nil, nav=false)
    if nav
      cookies["bunch__nav"] = {
        value:    "open", 
        expires:  365.days.from_now
      }
    end
  end

  # Delete cookie
  def delete_cookie
    cookies.delete(GeventAnalysis::Application::CONSTS[:cookie_name], domain: :all)
  end

  # Protected methods
  #----------------------------------------------------------------------
  protected

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end
end
