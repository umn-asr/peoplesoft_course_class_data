module PeoplesoftCourseClassData
  module Qas
    class StartSyncPollQuery
      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def run(payload)
        response = soap_request.execute_request('QAS_EXECUTEQRYSYNCPOLL_OPER.VERSION_1', payload)
        query_instance(response)
      end

      private
      attr_accessor :soap_request

      def query_instance(xml)
        xml.remove_namespaces!
        xml.at('QueryInstance').text
      end
    end
  end
end