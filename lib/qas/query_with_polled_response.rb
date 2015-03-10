module PeoplesoftCourseClassData
  module Qas
    class QueryWithPolledResponse
      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def run(payload, &block)
        query_instance = StartSyncPollQuery.new(soap_request).run(payload)
        GetQueryResults.new(soap_request, query_instance).poll(&block)
      end

      private
      attr_accessor :soap_request
    end
  end
end