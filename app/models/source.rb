class Source < ActiveRecord::Base

  # Constants
  #----------------------------------------------------------------------

  # Associations
  #----------------------------------------------------------------------
  belongs_to :user

  # Validations
  #----------------------------------------------------------------------

  # Scopes
  #----------------------------------------------------------------------

  # Callbacks
  #----------------------------------------------------------------------

  # oAuth Token methods
  #----------------------------------------------------------------------  
  def self.from_omniauth(auth, user)
    source = where(user_id: user.id).first
    source_params = {
        name: auth.info.name,
        email: auth.info.email,
        provider: auth.provider, uid: auth.uid,
        oauth_token: auth.credentials.token,
        oauth_refresh_token: auth.credentials.refresh_token,
        oauth_expires_at: Time.at(auth.credentials.expires_at)
    }
    if source.present?
      source.update_attributes(source_params)
    else
      source = user.sources.build(source_params)
    end
    source.save
  end

  def refresh_token_if_expired
    refresh_oauth_token if self.token_expired?
  end
  
  def token_expired?
    expiry = Time.parse(self.oauth_expires_at.to_s) 
    return true if expiry < Time.now
    false
  end
  
  def refresh_oauth_token
    client = Google::APIClient.new(application_name: 'Bunch')
    client.authorization.client_id = GeventAnalysis::Application.config.google_id
    client.authorization.client_secret = GeventAnalysis::Application.config.google_secret
    client.authorization.grant_type = 'refresh_token'
    client.authorization.refresh_token = self.oauth_refresh_token
    client.authorization.fetch_access_token!
    update_attributes(oauth_token: client.authorization.access_token,
                      oauth_expires_at: DateTime.now + client.authorization.expires_in.to_i.seconds)
  end

end
