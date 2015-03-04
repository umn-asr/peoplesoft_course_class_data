module PeoplesoftCourseClassData
  module Qas
    class QueryWithPolledResponse
      def initialize(soap_request)
        self.soap_request = soap_request
      end
      def query(payload)

      end

      private
      attr_accessor :soap_request
    end
  end
end