module PeoplesoftCourseClassData
  module Qas
    class StartSyncPollQuery
      class UnexpectedResponse < StandardError; end

      def initialize(soap_request)
        self.soap_request = soap_request
      end

      def run(payload)
        response = soap_request.execute_request("QAS_EXECUTEQRYSYNCPOLL_OPER.VERSION_1", payload)
        query_instance(response)
      end

      private

      attr_accessor :soap_request

      def query_instance(xml)
        xml.remove_namespaces!
        xml.at("QueryInstance").text
      rescue
        if xml.at("Fault")
          raise PeoplesoftCourseClassData::Qas::SoapEnvError, xml.at("DefaultMessage").text
        else
          raise PeoplesoftCourseClassData::Qas::StartSyncPollQuery::UnexpectedResponse, xml.to_xml
        end
      end
    end
  end
end
