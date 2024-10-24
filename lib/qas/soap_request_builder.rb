module PeoplesoftCourseClassData
  module Qas
    class SoapRequestBuilder
      def self.build(env)
        new(env).build
      end

      def initialize(env)
        self.env = env
      end

      def build
        SoapRequest.new(endpoint, Credentials.new(username, password))
      end

      private

      attr_accessor :env

      def endpoint
        PeoplesoftCourseClassData::Config::CREDENTIALS[env][:endpoint]
      end

      def username
        PeoplesoftCourseClassData::Config::CREDENTIALS[env][:username]
      end

      def password
        PeoplesoftCourseClassData::Config::CREDENTIALS[env][:password]
      end
    end
  end
end
