class UserboardController < ApplicationController
  include UserboardHelper

  before_action :authenticate_user!
  before_action :authenticate_verify_user
  before_action :authenticate_app_user
  
  layout "userboard"

  # General actions
  #----------------------------------------------------------------------
  # GET   /dashboard(.:format)
  def index
    # With sample events
    # events = EventAnalysis::SAMPLE_EVENTS2
    # @analysis_results = EventAnalysis.new(current_user.sources.first, events).analyze

    events = current_user.fetch_next_week_events
    @analysis_results = current_user.analyze_events(events)
    
    respond_to do |format|
      format.html{ render layout: params[:type] != "ajax" }
      format.json{ render json: EventDatatable.new(view_context, current_user, events) }
    end
  end


  # Private methods
  #----------------------------------------------------------------------
  private

end