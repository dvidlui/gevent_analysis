require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'will_paginate/array'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'will_paginate/array'
require 'google/api_client'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'net/imap'
require 'net/http'
require 'date'
require 'time'
require 'rest-client'

module GeventAnalysis
  class Application < Rails::Application
    CONSTS = {
      app_name:         "GeventAnalysis",
      app_host:         "http://dvidlui-gevent-analysis.herokuapp.com",
      contact_email:    "admin@nobl.io",
      log_out:          "bunch_log_out",
      cookie_name:       "_bunch",
      expire_time:      30.minutes,

      dev_host:         "http://localhost:4050",
      dev_ip:           "localhost",
      dev_port:         "4050"
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # for custom 404 error page
    require Rails.root.join("lib/custom_public_exceptions")
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)

    # For loading environment variables defined in local yaml
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'app_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    # For RESTful API by Grape
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
  end
end
