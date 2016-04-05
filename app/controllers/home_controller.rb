class HomeController < ApplicationController

  # Static Page actions
  #----------------------------------------------------------------------
  # GET   /
  def index
    if current_user.present?
      user = current_user
      flash[:error] = nil
      if user.has_profile?
        if user.time_span_in_DHMS[0] > 6.months / 1.day
          redirect_to profile_dashboard_users_path + NEW_USER
        else
          user.confirm! if user.confirmation_token.present?
          if user.admin_user?
            redirect_to dashboard_path
          else
            redirect_to userboard_path
          end
        end
      else
        redirect_to profile_dashboard_users_path + NEW_USER
      end
    else
      sign_out(:user)
      delete_cookie
    end
  end

  # GET   /authorization(.:format)
  def authorization
  end

  # Private methods
  #----------------------------------------------------------------------
  private

end