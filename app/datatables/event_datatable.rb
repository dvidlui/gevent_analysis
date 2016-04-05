class EventDatatable
  include DatatableHelper

  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  DATE_FORMAT = "%a, %b %-d, %l:%M %P"

  def initialize(view, user, events)
    @user = user
    @view = view
    @events = events
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: events.count,
      iTotalDisplayRecords: events.count,
      aaData: data.compact
    }
  end

  private

  def data
    events.map do |e|
      start_date = e[:start_date].present? ? e[:start_date].strftime(DATE_FORMAT) : nil
      end_date = e[:end_date].present? ? e[:end_date].strftime(DATE_FORMAT) : nil
      attendees = e[:attendees].map { |person| person[:name] || person[:email] }
      attendees = attendees.to_sentence
      [
        e[:title],
        e[:creator][:name] || e[:creator][:email],
        start_date,
        end_date,
        attendees
      ]
    end
  end

  def events
    @events ||= fetch_events
  end

  def fetch_events
    events = @events
      events = sort_array_with_data(events, sort_column, sort_direction)
    events.paginate(page: page, per_page: per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 15
  end

  def sort_column
    columns = %w[title creator start_date end_date]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end