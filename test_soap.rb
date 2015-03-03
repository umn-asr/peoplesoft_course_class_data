require           'nokogiri'
require_relative  'config/credentials'

class LogFormat
  def prettify_xml(string, indent=2)
    doc = Nokogiri.XML(string) do |config|
      config.default_xml.noblanks
    end
    strip_password(doc.to_xml(:indent => indent))
  end

  def strip_password(xml)
    xml.gsub(/\<wsse\:Password\>.*\<\/wsse\:Password\>/, '<wsse:Password>PASSWORD_STRIPPED</wsse:Password>')
  end
end


class SoapRequest
  def initialize(endpoint, credentials, logger = LogFormat.new)
    self.endpoint = endpoint
    self.username = credentials.username
    self.password = credentials.password
    self.logger   = logger
  end

  def execute_request(action, message)
     #puts "  Sending data to #{endpoint}:\n\n#{prettify_xml(payload)}\n\n"
     #puts "  Response:\n\n"
    # puts logger.prettify_xml(request(message))
    puts request(message)
    x = "curl -s -X POST -H 'Connection: Keep-Alive' -H 'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)' -H 'Expect: ' -H 'SOAPAction: \"#{action}\"' -H 'Content-type: text/xml;charset=UTF-8' -H 'Accept-Encoding: gzip,deflate' -d '#{request(message)}' #{endpoint}"
    `#{x}`
  end

  private
  attr_accessor :endpoint, :username, :password, :logger

  def request(message)
    payload = <<-EOXML
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:qas="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ_MSG.VERSION_1" xmlns:qas1="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ.VERSION_1">
    #{soap_header}
      <soapenv:Body>
      #{message}
      </soapenv:Body>
    </soapenv:Envelope>
    EOXML
    payload
  end

  def soap_header
    header = <<-EOH
      <soapenv:Header xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
        <wsse:Security soap:mustUnderstand="1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
          <wsse:UsernameToken>
            <wsse:Username>#{username}</wsse:Username>
            <wsse:Password>#{password}</wsse:Password>
          </wsse:UsernameToken>
        </wsse:Security>
      </soapenv:Header>
    EOH
  end
end

class QasSoapQuery
  def initialize(soap_request, logger = LogFormat.new)
    self.soap_request = soap_request
    self.logger       = logger
  end

  def query(query_body)
    response = soap_request.execute_request(query_type, query_body)
    puts logger.prettify_xml(response)

    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end

  private
  attr_accessor :soap_request, :logger
end

class QasStartSyncPollQuery < QasSoapQuery

  def query(query_body)
    response = super
    response.remove_namespaces!
    query_instance(response)
  end

  private
  def query_instance(response)
    response.at('QueryInstance').text
  end

  def query_type
    "QAS_EXECUTEQRYSYNCPOLL_OPER.VERSION_1"
  end
end

class QasGetQueryResults < QasSoapQuery

  def initialize(soap_request, logger = LogFormat.new)
    self.block_number = 1
    self.backoff      = 2
    super
  end

  def poll_for_response(query_instance)
    loop do
      response = query(request_next_block(block_number, query_instance))

      if status(response) == 'queued'
        sleep_and_backoff
      elsif status(response) == 'blockRetrieved'
        yield response

        reset_backoff
        set_next_block_to_fetch
      else
        break
      end
    end
  end

  private
  attr_accessor :block_number, :backoff

  def request_next_block(block_number, query_instance)
    payload = <<-EOXML
      <qas:QAS_GETQUERYRESULTS_REQ_MSG>
         <qas:QAS_GETQUERYRESULTS_REQ>
            <qas1:PTQASWRK class="R">
               <qas1:BlockNumber>#{block_number}</qas1:BlockNumber>
               <qas1:QueryInstance>#{query_instance}</qas1:QueryInstance>
            </qas1:PTQASWRK>
         </qas:QAS_GETQUERYRESULTS_REQ>
      </qas:QAS_GETQUERYRESULTS_REQ_MSG>
    EOXML
    payload
  end

  def query_type
    "QAS_GETQUERYRESULTS_OPER.VERSION_2"
  end

  def status(response)
    response.xpath('//xmlns:status', 'xmlns' => 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2').text
  end

  def reset_backoff
    self.backoff = 2
  end

  def sleep_and_backoff
    sleep(backoff)
    self.backoff = backoff * 2
  end

  def set_next_block_to_fetch
    self.block_number += 1
  end
end

class ClassDataService
  def initialize(soap_request, logger = LogFormat.new)
    self.soap_request = soap_request
    self.logger       = logger
  end

  def query(institution, campus, term, &block)
    query_body = class_query(institution, campus, term)
    query_instance = QasStartSyncPollQuery.new(soap_request).query(query_body)
    QasGetQueryResults.new(soap_request).poll_for_response(query_instance, &block)
  end

  private
  attr_accessor :soap_request, :logger

  def class_query(institution, campus, term)
    query = <<-EOXML
      <qas:QAS_EXEQRYSYNCPOLL_REQ_MSG>
         <qas1:QAS_EXEQRYSYNCPOLL_REQ>
            <QueryName>UM_SR003_0021_CLASS_DATA</QueryName>
            <isConnectedQuery>N</isConnectedQuery>
            <OwnerType>PUBLIC</OwnerType>
            <BlockSizeKB>0</BlockSizeKB>
            <MaxRow>0</MaxRow>
            <OutResultType>XMLP</OutResultType>
            <OutResultFormat>NONFILE</OutResultFormat>
            <Prompts>
               <PROMPT>
                  <PSQueryName>UM_SR003_0021_CLASS_DATA</PSQueryName>
                  <UniquePromptName>INSTITUTION</UniquePromptName>
                  <FieldValue>#{institution}</FieldValue>
               </PROMPT>
               <PROMPT>
                  <PSQueryName>UM_SR003_0021_CLASS_DATA</PSQueryName>
                  <UniquePromptName>CAMPUS</UniquePromptName>
                  <FieldValue>#{campus}</FieldValue>
               </PROMPT>
               <PROMPT>
                  <PSQueryName>UM_SR003_0021_CLASS_DATA</PSQueryName>
                  <UniquePromptName>STRM</UniquePromptName>
                  <FieldValue>#{term}</FieldValue>
               </PROMPT>
            </Prompts>
            <FieldsFilter>
               <FilterFieldName></FilterFieldName>
            </FieldsFilter>
         </qas1:QAS_EXEQRYSYNCPOLL_REQ>
      </qas:QAS_EXEQRYSYNCPOLL_REQ_MSG>
    EOXML
    query
  end
end

Credentials = Struct.new(:username, :password)

class CredentialBuilder
  def self.credentials(env)
    new(env).build
  end

  def initialize(env)
    self.env = env
  end

  def build
    Credentials.new(
                    CONFIG[:services]["QAS_EXEQRYSYNCPOLL_REQ"][env][:username],
                    CONFIG[:services]["QAS_EXEQRYSYNCPOLL_REQ"][env][:password]
                    )
  end

  private
  attr_accessor :env
end

class SoapRequestBuilder
  def self.build(env, credential_builder = CredentialBuilder)
    new(env, credential_builder).build
  end

  def initialize(env, credential_builder = CredentialBuilder)
    self.env                = env
    self.credential_builder = credential_builder
  end

  def build
    SoapRequest.new(env_endpoint, credential_builder.credentials(env))
  end

  private
  attr_accessor :env, :credential_builder

  def env_endpoint
    CONFIG[:endpoints][env]
  end
end



env = :dev
soap_request = SoapRequestBuilder.build(env)
class_service = ClassDataService.new(soap_request)
f = File.new("response_test_for_#{env}.xml",'w+')

class_service.query('UMNTC', 'UMNTC', 1149) do |response|
  f.write(response)
end
