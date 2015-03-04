module PeoplesoftCourseClassData
  module Qas
    class GetQueryResults
      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def poll(query_id)

      end

      private
      attr_accessor :soap_request
    end
  end
end