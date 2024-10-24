# Don't change this file!
# Configure your daemon in config/environment.rb

DAEMON_ROOT = "#{__dir__}/.." unless defined?(DAEMON_ROOT)

require "rubygems"
require "bundler/setup"

module DaemonKit
  class << self
    def boot!
      unless booted?
        GemBoot.new.run
      end
    end

    def booted?
      defined? DaemonKit::Initializer
    end
  end

  class Boot
    def run
      load_initializer
      DaemonKit::Initializer.run
    end
  end

  class GemBoot < Boot
    def load_initializer
      require "rubygems" unless defined?(::Gem)
      gem "daemon-kit"
      require "daemon_kit/initializer"
    rescue ::Gem::LoadError
      msg = <<~EOF
        
        You are missing the daemon-kit gem. Please install the following gem:
        
        sudo gem install daemon-kit
        
      EOF
      warn msg
      exit 1
    end
  end
end

DaemonKit.boot!
