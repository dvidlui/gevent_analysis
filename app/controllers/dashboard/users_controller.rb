class Dashboard::UsersController < DashboardController

  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_verify_user, except: [:profile, :update_profile]
  before_action :authenticate_admin_user, except: [:profile, :update_profile]  

  # User actions
  #----------------------------------------------------------------------
  # GET /dashboard/users/new(.:format)
  def new
    @user = User.new
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST  /dashboard/users(.:format)
  def create
    user = User.new(user_params)
    user.skip_confirmation!
    if user.save
      data = {success: {msg: "User added", name: user.name}}
    else
      key, val = user.errors.messages.first
      data = {failure:{msg: user.errors.full_messages.first, element_id: "user_#{key}"}}
    end
    render json: data
  end

  # GET /dashboard/users/:id/edit(.:format)
  def edit
    @user = User.find(params[:id])
    render layout: params[:type] != "ajax"
  end

  # PUT|PATCH /dashboard/users/:id(.:format)
  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      data = {success:{msg: "User Updated", name: user.name}}
    else
      key, val = user.errors.messages.first
      data = {failure:{msg: user.errors.full_messages.first, element_id: "user_#{key}"}}
    end
    render json: data
  end

  # POST  /dashboard/users/:id/send_invite(.:format)
  def send_invite
    user = User.find(params[:id])
    if user.present? && user.update_attributes(invitation_sent_at: DateTime.now.to_date)
      user.send_confirmation_instructions
      render json: {success:{msg: "Invitation has been sent successfully."}}
    else
      render json: {success:{msg: "User doesn't exist."}}
    end
  end

  # Common actions
  #----------------------------------------------------------------------
  # GET   /dashboard/users/profile(.:format)
  # type - If type value is 'new_user' : profile page will be displayed without layout
  #                     not 'new_user' : profile page will be displayed with dashboard layout
  def profile
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    redirect_to root_url unless @user.present?
    render layout: true
  end

  # PUT|PATCH   /dashboard/users/update_profile(.:format)
  def update_profile
    @user = User.find(params[:user_id])
    @user.confirm!
    # @user.skip_reconfirmation! 
    if params[:type] == "admin"  &&  current_user.super_admin?
      if @user.update_attributes(user_params)
        @user.reset_profile
        if current_user == @user
          sign_in @user, bypass: true 
          set_cookie(@user.email)
        end
        render json: {success: {msg: t("controllers.dashboard.update_profile.success_msg")}} and return
      else 
        render json: {failed: {msg: @user.errors.full_messages.first}} and return
      end
    else
      if @user.update_attributes(user_params)
        if current_user == @user
          sign_in @user, bypass: true 
          set_cookie(@user.email)
        end
        redirect_to userboard_path
      else
        respond_to do |format|
          format.html { render action: :profile }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # Private methods
  #----------------------------------------------------------------------
  private

  def user_params
    if action_name == "create"
      password = User.random_password
      params[:user][:password] = params[:user][:password_confirmation] = password
    end
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end