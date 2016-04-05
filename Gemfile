source 'https://rubygems.org'

ruby '2.1.4'

gem 'rails', '4.1.0'

# Use mysql as the database for Active Record
gem 'mysql2'

# for Web server
gem 'puma'
gem 'rack-timeout'

# Cache server
# gem 'redis'

gem 'nokogiri'
gem 'binding_of_caller'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'haml-rails'
gem 'haml2slim'
gem 'html2haml'
gem 'parsley-rails'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'autoprefixer-rails'
gem 'simple_form'
# for loading indicator of all ajax call events
gem 'spinjs-rails'

gem 'devise'
gem 'omniauth-google-oauth2'
gem 'bcrypt'
gem 'newrelic_rpm' # for project diagnostics

gem 'mandrill-api'
gem 'mandrill_mailer'

gem 'google-api-client'

gem 'paperclip'
gem 'aws-sdk', '~> 1.33.0'
gem 'remotipart' # for Ajax File Upload

gem 'will_paginate'

# related to country, state and city
gem 'country_select'
gem 'carmen'
gem 'carmen-rails', '~> 1.0.1'
gem 'geoip'

gem 'lazy_high_charts'

# for data tables
gem 'jquery-datatables-rails', '~> 3.0.0'
gem 'jquery-ui-rails'

gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemon-spawn'

# for External APIs
gem 'rest-client'

# for RESTful API framework
gem 'grape'

# Hash for API
gem 'hashids'

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'therubyracer', :platforms => :ruby
end

group :development do
  gem 'better_errors'  
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'letter_opener' # for checking email template in local development environment
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'railroady' # for making svg diagram
  gem 'whenever', :require => false # for cron job
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

group :production, :heroku do
  gem 'rails_12factor'
end