module PeoplesoftCourseClassData
  module Qas
    class GetQueryResults

      class SoapEnvError < StandardError; end
      class MaximumAttemptsExceededError < StandardError; end

      class PollingConfiguration
        attr_reader :maximum_attempts

        def initialize(maximum_attempts = 50)
          self.maximum_attempts = maximum_attempts
        end

        private
        attr_writer :maximum_attempts
      end

      def initialize(soap_request, query_instance, polling_config = PollingConfiguration.new)
        self.soap_request   = soap_request
        self.query_instance = query_instance
        self.polling_config = polling_config
      end

      def poll
        block_number = 1
        attempts = 0
        loop do
          attempts += 1
          response = request_block(block_number)
          if status(response) == 'queued' && !maximum_attempts_exceeded(attempts)
            sleep 2
          elsif status(response) == 'blockRetrieved'
            yield response
            block_number += 1
          elsif status(response) == 'finalBlockRetrieved'
            yield response
            break
          else
            if maximum_attempts_exceeded(attempts)
              raise MaximumAttemptsExceededError
            else
              raise SoapEnvError, response.xpath('//detail').to_s
            end
          end
        end
      end

      private
      attr_accessor :soap_request, :query_instance, :polling_config

      def status(response)
        response.xpath('//xmlns:status', 'xmlns' => 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2').text
      end

      def request_block(block_number)
        soap_request.execute_request('QAS_GETQUERYRESULTS_OPER.VERSION_2', block_request(block_number))
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

      def maximum_attempts_exceeded(attempts)
        attempts >= polling_config.maximum_attempts
      end
    end
  end
end