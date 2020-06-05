# Generated cron daemon

# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  # config.trap( 'INT' ) do
  #   # do something clever
  # end
  # config.trap( 'TERM', Proc.new { puts 'Going down' } )
end

# Configuration documentation available at http://rufus.rubyforge.org/rufus-scheduler/
# An instance of the scheduler is available through
# DaemonKit::Cron.scheduler

# To make use of the EventMachine-powered scheduler, uncomment the
# line below *before* adding any schedules.
# DaemonKit::EM.run

# Some samples to get you going:

# Will call #regenerate_monthly_report in 3 days from starting up
#DaemonKit::Cron.scheduler.in("3d") do
#  regenerate_monthly_report()
#end
#
#DaemonKit::Cron.scheduler.every "10m10s" do
#  check_score(favourite_team) # every 10 minutes and 10 seconds
#end
#
#DaemonKit::Cron.scheduler.cron "0 22 * * 1-5" do
#  DaemonKit.logger.info "activating security system..."
#  activate_security_system()
#end
#
# Example error handling (NOTE: all exceptions in scheduled tasks are logged)
DaemonKit::Cron.handle_exception do |job, exception|
  mail         = ::Mail.new
  mail.from    = 'asrweb@umn.edu'
  mail.to      = 'ASR-WEB-ERRORS@lists.umn.edu'
  mail.subject = "Peoplesoft Course Class Data [#{ENV['DAEMON_ENV']}] - Exception"

  mail.body = <<-EOF
    An exception occured, details below:
    Type: #{exception.class.name}
    Message: #{exception.message}
    EOF

  mail.deliver
end

DaemonKit::Cron.scheduler.cron "45 13 * * 0-6" do
  path = "#{PeoplesoftCourseClassData::Config::FILE_ROOT}"
  env = PeoplesoftCourseClassData::Config::PS_ENV
  runner = ::RakeRunner::RakeRunner.new

  DaemonKit.logger.info "task: 'peoplesoft_course_class_data:download'; status: started"
  runner.run "bundle exec rake -f #{path}/tasks/peoplesoft_course_class_data.rake peoplesoft_course_class_data:download['#{env}','#{path}/tmp']"
  DaemonKit.logger.info "task: 'peoplesoft_course_class_data:download'; status: completed"

  DaemonKit.logger.info "task: 'peoplesoft_course_class_data:copy_good_files'; status: started"
  runner.run "bundle exec rake -f #{path}/tasks/peoplesoft_course_class_data.rake peoplesoft_course_class_data:copy_good_files['#{path}/tmp','#{path}/json_tmp']"
  DaemonKit.logger.info "task: 'peoplesoft_course_class_data:copy_good_files'; status: completed"
end


# Run our 'cron' dameon, suspending the current thread
DaemonKit::Cron.run
