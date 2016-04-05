class DashboardController < ApplicationController
  include DashboardHelper

  before_action :authenticate_user!
  before_action :authenticate_verify_user
  before_action :authenticate_admin_user
  
  layout "dashboard"

  # General actions
  #----------------------------------------------------------------------
  # GET   /dashboard(.:format)
  def index
    respond_to do |format|
      format.html{ render layout: params[:type] != "ajax" }
      format.json{ render json: UserDatatable.new(view_context) }
    end
  end

  # Public actions
  #----------------------------------------------------------------------
  # POST  /dashboard/update_status(.:format)
  def update_status
    update_params = {status: params[:status]}
    update_params[:password] = "" if params[:object] == "User"

    model = params[:object].constantize
    object = model.find(params[:status_id])
    if object.update_attributes(update_params)
      render json: {success:{msg: "Updated #{params[:object]}", id: object.id.to_s}}
    else      
      render json: {failure:{msg: object.errors.full_messages.first}}
    end
  end

  # Private methods
  #----------------------------------------------------------------------

end