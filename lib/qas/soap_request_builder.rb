require_relative 'soap_request'

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
        PeoplesoftCourseClassData::CONFIG[env][:endpoint]
      end

      def username
        PeoplesoftCourseClassData::CONFIG[env][:username]
      end

      def password
        PeoplesoftCourseClassData::CONFIG[env][:password]
      end
    end
  end
end