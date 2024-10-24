require File.expand_path("../config/boot", __FILE__)

require "rake"
require "daemon_kit/tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

Dir[File.join(File.dirname(__FILE__), "tasks/*.rake")].each { |rake| load rake }
