module UserboardHelper
  # Public: Check if the user is app user.
  def authenticate_app_user
    if current_user.app_user?
      return true
    else
      redirect_to dashboard_path
    end
  end
end