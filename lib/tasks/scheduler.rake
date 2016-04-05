# desc "This task is called by the Heroku scheduler add-on"
task :test_send_weekly_analysis_report => :environment do
  puts "Test for sending weeklky analyssis for dvidlui@gmail, megan.foy@nobl.io"
  User.test_send_weekly_analysis_report
  puts "done."
end

# desc "This task is called by the Heroku scheduler add-on"
task :send_weekly_analysis_report => :environment do
  if Time.now.sunday?
    puts "Sending weeklky analyssis for all users"
    User.send_weekly_analysis_report
    puts "done."
  end
end