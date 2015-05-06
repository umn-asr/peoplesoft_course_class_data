require_relative 'soap_request'
require_relative 'credentials'
require_relative 'soap_request_builder'
require_relative 'query_with_polled_response'
require_relative 'start_sync_poll_query'
require_relative 'get_query_results'

module PeoplesoftCourseClassData
  module Qas
    class SoapEnvError < StandardError; end
  end
end