RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../../'))
Delayed::Worker.logger = Logger.new(File.join(RAILS_ROOT, "log", "delayed_job.log"))