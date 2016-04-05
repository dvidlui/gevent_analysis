class Googledata
  
  attr_accessor :type, :scope, :api, :api_version, :max_results, :page_list, :next_page, :parameters, :current_page
  
  def initialize (type="calendar")
    self.type = type
    self.next_page = nil
    self.current_page = nil
    self.max_results = '30'
    self.page_list = []
    self.api = "calendar"
    self.api_version = 'v3'
    self.scope = 'https://www.googleapis.com/auth/calendar'
  end
  
  def parameters
    parameters = {}
    if defined?(self.max_results) && !self.max_results.nil?
      parameters.merge!('maxResults' => self.max_results)
    end
    if defined?(self.next_page) && self.next_page != nil
      parameters.merge!('pageToken' => self.next_page)
    end    
    parameters.merge!('calendarId' => 'primary', 'singleEvents' => 'true', 'orderBy' => 'startTime', 
                      'timeMin' => DateTime.now.next_week, 'timeMax' => DateTime.now.next_week.next_day(5))
    return parameters
  end
  
  # Fetches events from Google calendar by a user's token
  def pull(token)
    api_client = Google::APIClient.new(application_name: 'Bunch')
    api_client.authorization.client_id = GeventAnalysis::Application.config.google_id
    api_client.authorization.client_secret = GeventAnalysis::Application.config.google_secret
    api_client.authorization.scope = self.scope
    auth = api_client.authorization.dup
    auth.update_token!(access_token: token)
    discovered_api ||= api_client.discovered_api(self.api, self.api_version)

    pull = api_client.execute(api_method: discovered_api.events.list, parameters: self.parameters, authorization: auth)
    self.current_page = self.next_page
    self.next_page = pull.data['nextPageToken']
    self.page_list << pull.data['nextPageToken']
    items = pull.data['items']
    result = []
    items.each do |item|
      start_date = check_item_date_time_for_key(item, :start)
      end_date   = check_item_date_time_for_key(item, :end)
      result << {title: item.summary, 
                 creator: {name: item.creator.try(:[], 'displayName'), email: item.creator.try(:[], 'email')},
                 start_date: start_date,
                 end_date: end_date,
                 attendees: attendees_from_event_item(item)
                }
    end
    return result
  end

  # Generates an array of attendees from an event item
  def attendees_from_event_item(item)
    result = []
    item.attendees.each do |person|
      result << {email: person.try(:[], 'email'), name: person.try(:[], 'displayName')}
    end
    result
  end

  # Fetches date info instead of dateTime from raw item
  def check_item_date_time_for_key(item, key)
    date_time = item.try(key).try(:[], 'dateTime')
    if date_time.nil?
      date_time = item.try(key).try(:[], 'date')
      if date_time.present?
        date_time = DateTime.parse(date_time.to_s)
      end
    end
    date_time
  end

end