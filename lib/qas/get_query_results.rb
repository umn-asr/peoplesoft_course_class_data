module PeoplesoftCourseClassData
  module Qas
    class GetQueryResults
      class SoapEnvError < StandardError; end

      def initialize(soap_request, query_instance)
        self.soap_request = soap_request
        self.query_instance = query_instance
      end

      def poll
        block_number = 1

        loop do
          response = request_block(block_number)
          if status(response) == "queued"
            sleep 2
          elsif status(response) == "blockRetrieved"
            yield response
            block_number += 1
          elsif status(response) == "finalBlockRetrieved"
            yield response
            break
          else
            raise SoapEnvError, response.xpath("//detail").to_s
          end
        end
      end

      private

      attr_accessor :soap_request, :query_instance

      def status(response)
        response.xpath("//xmlns:status", "xmlns" => "http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2").text
      end

      def request_block(block_number)
        soap_request.execute_request("QAS_GETQUERYRESULTS_OPER.VERSION_2", block_request(block_number))
      end

      def block_request(block_number)
        <<-EOXML
          <qas:QAS_GETQUERYRESULTS_REQ_MSG>
             <qas:QAS_GETQUERYRESULTS_REQ>
                <qas1:PTQASWRK class="R">
                   <qas1:BlockNumber>#{block_number}</qas1:BlockNumber>
                   <qas1:QueryInstance>#{query_instance}</qas1:QueryInstance>
                </qas1:PTQASWRK>
             </qas:QAS_GETQUERYRESULTS_REQ>
          </qas:QAS_GETQUERYRESULTS_REQ_MSG>
        EOXML
      end
    end
  end
end
