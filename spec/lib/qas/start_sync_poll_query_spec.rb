require_relative '../../../lib/qas/start_sync_poll_query'
require          'nokogiri'

RSpec.describe PeoplesoftCourseClassData::Qas::StartSyncPollQuery do
  let(:soap_request_double)  { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }

  subject { PeoplesoftCourseClassData::Qas::StartSyncPollQuery.new(soap_request_double) }

  describe "run" do
    let(:payload)        { "<xml>Enterprise!</xml>"}
    let(:query_instance) { SecureRandom.urlsafe_base64 }
    let(:response)       { sync_poll_response(query_instance) }

    it "executes a soap request with an action of 'QAS_EXECUTEQRYSYNCPOLL_OPER.VERSION_1' and the query payload" do
      expect(soap_request_double).to receive(:execute_request).with('QAS_EXECUTEQRYSYNCPOLL_OPER.VERSION_1', payload) { response }

      subject.run(payload)
    end
    it "returns the value of the QueryInstance element" do
      allow(soap_request_double).to receive(:execute_request) { response }

      expect(subject.run(payload)).to eq(query_instance)
    end
  end

  def sync_poll_response(query_instance)
    response = <<-RESPONSE
                  <?xml version="1.0" encoding="UTF-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <soapenv:Body>
                      <QAS_EXEQRYSYNCPOLL_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_EXEQRYSYNCPOLL_RESP_MSG.VERSION_1">
                        <QAS_EXEQRYSYNCPOLL_RESP>
                          <PTQASWRK xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_EXEQRYSYNCPOLL_RESP.VERSION_1" class="R">
                            <QueryInstance>#{query_instance}</QueryInstance>
                          </PTQASWRK>
                        </QAS_EXEQRYSYNCPOLL_RESP>
                      </QAS_EXEQRYSYNCPOLL_RESP_MSG>
                    </soapenv:Body>
                  </soapenv:Envelope>
               RESPONSE
    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end
end