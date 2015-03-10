require_relative 'qas/credentials'

module PeoplesoftCourseClassData
  class CredentialsBuilder
    def self.build(env)
      new(env).build
    end

    def initialize(env)
      self.env = env
    end

    def build
      Qas::Credentials.new(username, password)
    end

    private
    attr_accessor :env
    def username
      CONFIG[env][:username]
    end

    def password
      CONFIG[env][:password]
    end
  end
end