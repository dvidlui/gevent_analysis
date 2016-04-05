class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, 
         :omniauthable, :omniauth_providers => [:google_oauth2],
         timeout_in: GeventAnalysis::Application::CONSTS[:expire_time]

  # Constants
  #----------------------------------------------------------------------
  MEMBER_TYPE = {admin: 1, app: 2}

  # Associations
  #----------------------------------------------------------------------
  has_many :sources, dependent: :destroy

  # Validations
  #----------------------------------------------------------------------

  # Scopes
  #----------------------------------------------------------------------

  # Callbacks
  #----------------------------------------------------------------------
  before_save :ensure_authentication_token
  before_save :titleize_names


  # Devise methods
  #----------------------------------------------------------------------
  # Public: Reset password in email confirmation
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # Public: Check if password exists or not
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Public: new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  # Public: Make authentication_token
  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  # Public: Check if the user has his own profile or not
  def has_profile?
    first_name.present? && last_name.present?
  end

  # Token methods
  #----------------------------------------------------------------------
  # Returns the hash digest of the given string
  def self.digest(string)
    Digest::SHA2.hexdigest("NOBL_Bunch"+string)
  end
  
  # Returns a random token.
  def self.new_token
    charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (0...40).map { charset[SecureRandom.random_number(charset.size)] }.join
  end

  # Generates activation_token
  def self.new_activation_token
    token = nil
    loop do
      token = User.new_token
      break unless User.where(activation_token: User.digest(token)).exists?
    end
    token
  end

  # Generates random password
  def self.random_password
    charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (0...6).map { charset[SecureRandom.random_number(charset.size)] }.join
  end

  # Validation methods
  #----------------------------------------------------------------------
  # Checks user is admin user
  def admin_user?
    member_type == MEMBER_TYPE[:admin]
  end

  # Checks user is app user
  def app_user?
    member_type == MEMBER_TYPE[:app]
  end

  # Checks user has any sources
  def has_no_source?
    sources.count == 0
  end

  # Attributes methods
  #----------------------------------------------------------------------
  # Gets elapsed time from last login
  def time_span_in_DHMS(passed_time=nil)
    passed_time = current_sign_in_at if passed_time.nil?
    time1 = Time.now
    time2 = passed_time
    days, remaining = (time1 - time2).to_i.abs.divmod(86400)
    hours, remaining = remaining.divmod(3600)
    minutes, seconds = remaining.divmod(60)
    [days, hours, minutes, seconds]
  end

  # Gets last logged in time string of current user
  def last_login
    passed_time = current_sign_in_at
    if passed_time.present?
      distance = time_span_in_DHMS(passed_time)
      if distance[0] > 1
        return distance[0].to_s + "d"
      elsif distance[1] > 1
        return distance[1].to_s + "h(s)"
      else
        "Online"
      end
    else
      ""
    end
  end

  # Gets full name of user
  def name
    if first_name.present?
      name = [first_name, last_name].join(" ")
    end
    name.present? ? name : ''
  end

  # Gets temporary email of app user
  def self.temp_email
    "app_user#{User.last.id+1}@email.com"
  end

  # Titleizes names
  def titleize_names
    self.first_name = first_name.titleize if first_name.present?
    self.last_name  = last_name.titleize if last_name.present?
  end

  # Calendar methods
  #----------------------------------------------------------------------  
  # Fetches next week events from user's Google calendar
  def fetch_next_week_events
    return [] unless sources.try(:first).present?

    source = sources.first
    source.refresh_token_if_expired

    gdata = Googledata.new
    gdata.pull(source.oauth_token)
  end

  # Returns the analyzed results from events
  def analyze_events(events)
    if events.count > 0
      analysis = EventAnalysis.new(sources.first, events)
      analysis.analyze
    else
      nil
    end
  end
  
  # Fetches next week events from user's Google calendar
  def fetch_next_week_events_and_analyze
    events = fetch_next_week_events
    analyze_events(events)
  end

  # Analyze each user's events and sends email report (Test for David and Megan)
  def self.test_send_weekly_analysis_report
    test_emails = ["demo1@email.com", "dvidlui@gmail.com", "megan.foy@nobl.io"]
    User.where(email: test_emails).each do |user|
      next unless user.app_user?
      p ">>> Analyzing events for #{user.email}"
      if user.sources.first.present?
        analysis_results = user.fetch_next_week_events_and_analyze
        UserMailer.weekly_analysis_report(user, analysis_results).deliver
      else
        UserMailer.link_gmail_note(user).deliver
      end
    end
  end

    # Analyze each user's events and sends email report
  def self.send_weekly_analysis_report
    User.all.each do |user|
      next unless user.app_user?
      p ">>> Analyzing events for #{user.email}"
      if user.sources.first.present?
        analysis_results = user.fetch_next_week_events_and_analyze
        UserMailer.weekly_analysis_report(user, analysis_results).deliver
      else
        UserMailer.link_gmail_note(user).deliver
      end
    end
  end
  
  # oAuth Token methods
  #----------------------------------------------------------------------  
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user.present?
      user.update_attributes(provider: auth.provider, uid: auth.uid,
         oauth_token: auth.credentials.token,
         oauth_refresh_token: auth.credentials.refresh_token,
         oauth_expires_at: Time.at(auth.credentials.expires_at)
      )
    else
      password = User.random_password
      user = User.new(#first_name: auth.info.first_name, last_name: auth.info.last_name,
         email: auth.info.email, password: password, password_confirmation: password,
         provider: auth.provider, uid: auth.uid,
         oauth_token: auth.credentials.token,
         oauth_refresh_token: auth.credentials.refresh_token,
         oauth_expires_at: Time.at(auth.credentials.expires_at)
      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  
  # Private methods
  #----------------------------------------------------------------------
  private

  # Private: Generate authentication token
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
