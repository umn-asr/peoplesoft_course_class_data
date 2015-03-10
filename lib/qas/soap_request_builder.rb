require_relative 'soap_request'
require_relative 'credentials_builder'

module PeoplesoftCourseClassData
  module Qas
    class SoapRequestBuilder
      def initialize(env)
        self.env = env
      end

      def build
        SoapRequest.new(endpoint, Credentials.new(username, password))
      end

      private
      attr_accessor :env

      def endpoint
        CONFIG[env][:endpoint]
      end

      def username
        CONFIG[env][:username]
      end

      def password
        CONFIG[env][:password]
      end
    end
  end
end