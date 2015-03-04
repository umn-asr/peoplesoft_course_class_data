module PeoplesoftCourseClassData
  module Qas
    class StartSyncPollQuery
      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def run(payload)
      end

      private
      attr_accessor :soap_request
    end
  end
end