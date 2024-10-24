module PeoplesoftCourseClassData
  module Qas
    class QueryWithPolledResponse
      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def run(payload, &)
        query_instance = StartSyncPollQuery.new(soap_request).run(payload)
        GetQueryResults.new(soap_request, query_instance).poll(&)
      end

      private

      attr_accessor :soap_request
    end
  end
end
