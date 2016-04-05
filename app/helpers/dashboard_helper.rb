module DashboardHelper
  # Public: Check if the user is admin
  def authenticate_admin_user
    if current_user.admin_user?
      return true
    else
      redirect_to userboard_path
    end
  end
end