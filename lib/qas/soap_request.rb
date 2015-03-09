require_relative 'credentials'

module PeoplesoftCourseClassData
  module Qas
    class SoapRequest
      def initialize(endpoint, credentials)
        self.endpoint     = endpoint
        self.credentials  = credentials
      end

      def execute_request(action, payload)
        `#{command(action, payload)}`
      end

      private
      attr_accessor :endpoint, :credentials

      def command(action, payload)
        xml = xml_request(payload)
        "curl -s -X POST -H 'Connection: Keep-Alive' -H 'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)' -H 'Expect: ' -H 'SOAPAction: \"#{action}\"' -H 'Content-type: text\/xml;charset=UTF-8' -H 'Accept-Encoding: gzip,deflate' -d '#{xml}' #{endpoint}"
      end

      def xml_request(payload)
        xml_request = <<-EOXML.gsub(/[\t\r\n\f]/, '')
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:qas="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ_MSG.VERSION_1" xmlns:qas1="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ.VERSION_1">
        #{soap_header}
          <soapenv:Body>
            #{payload}
          </soapenv:Body>
        </soapenv:Envelope>
        EOXML
      end

      def soap_header
        <<-EOH
        <soapenv:Header xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
          <wsse:Security soap:mustUnderstand="1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <wsse:UsernameToken>
              <wsse:Username>#{credentials.username}</wsse:Username>
              <wsse:Password>#{credentials.password}</wsse:Password>
            </wsse:UsernameToken>
          </wsse:Security>
        </soapenv:Header>
        EOH
      end
    end
  end
end