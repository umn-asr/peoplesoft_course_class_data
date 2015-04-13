require File.expand_path('../config/boot',  __FILE__)

require "rspec/core/rake_task"
require 'rake'
require 'daemon_kit/tasks'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |rake| load rake }
