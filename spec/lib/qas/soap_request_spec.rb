require_relative '../../../lib/qas/soap_request'

RSpec.describe PeoplesoftCourseClassData::Qas::SoapRequest do
  let(:endpoint)      { "https://some_url/#{rand(1_000..9_999)}" }
  let(:credentials)   { PeoplesoftCourseClassData::Qas::Credentials.new("username#{rand(100..999)}", "password#{rand(100..999)}") }

  subject { PeoplesoftCourseClassData::Qas::SoapRequest.new(endpoint, credentials) }

  describe "#execute_request" do
    let(:action)      { "QAS_EXECUTESOMEQUERY_OPER.VERSION_#{rand(1..9)}" }
    let(:payload)      { "<qas:QAS_EXEQRYSYNCPOLL_REQ_MSG><qas1:QAS_EXEQRYSYNCPOLL_REQ>Enterprise!</<qas1:QAS_EXEQRYSYNCPOLL_REQ></qas:QAS_EXEQRYSYNCPOLL_REQ_MSG>" }

    before do
      allow(subject).to receive(:'`')
    end

    it "shells out curl request to the endpoint" do
      base_curl_command = /curl -s -X POST -H 'Connection: Keep-Alive' -H 'User-Agent: Apache-HttpClient\/4.1.1 \(java 1.5\)' -H 'Expect: ' -H 'SOAPAction: ".*"' -H 'Content-type: text\/xml;charset=UTF-8' -H 'Accept-Encoding: gzip,deflate' -d '.*' .*/
      expect(subject).to receive(:'`').with(base_curl_command)
      subject.execute_request(action, payload)
    end

    it "sends action as 'SOAPAction:'" do
      expect(subject).to receive(:'`').with(/'SOAPAction: "#{action}"'/)
      subject.execute_request(action, payload)
    end


    describe "the data" do
      it "send the payload as part of the -d data" do
        expect(subject).to receive(:'`').with(/-d '.*#{payload}.*' /)
        subject.execute_request(action, payload)
      end

      it "sends the payload wrapped in a <soapenv:Body> tag" do
        soap_body_start = "<soapenv:Body>"
        soap_body_end   = "</soapenv:Body>"
        expect(subject).to receive(:'`').with(/-d '.*#{soap_body_start}.*#{payload}.*#{soap_body_end}.*' /)
        subject.execute_request(action, payload)
      end

      it "wraps it in a soap envelope" do
        soap_envelope_start = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:qas="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ_MSG.VERSION_1" xmlns:qas1="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_REQ.VERSION_1">'
        soap_envelope_end   = '</soapenv:Envelope>'
        soap_envelope_matcher = /-d '.*#{soap_envelope_start}.*#{soap_envelope_end}.*'/
        expect(subject).to receive(:'`').with(soap_envelope_matcher)
        subject.execute_request(action, payload)
      end

      it "builds a header with the credentials username and password" do
        soap_header = <<-HEADER.gsub(/[\t\r\n\f]/, '')
        <soapenv:Header xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
          <wsse:Security soap:mustUnderstand="1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <wsse:UsernameToken>
              <wsse:Username>#{credentials.username}</wsse:Username>
              <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">#{credentials.password}</wsse:Password>
            </wsse:UsernameToken>
          </wsse:Security>
        </soapenv:Header>
        HEADER
        expect(subject).to receive(:'`').with(/-d '.*#{soap_header}.*'/)
        subject.execute_request(action, payload)
      end
    end

    describe "the response format" do
      let(:response_string) { "<some_enterprise_xml>EnterpriseData</some_enterprise_xml>" }
      before do
        allow(subject).to receive(:'`').and_return(response_string)
      end

      it "parses the reponse with Nokogiri::XML" do
        expect(Nokogiri::XML::Document).to receive(:parse).with(response_string, any_args)
        subject.execute_request(action, payload)
      end
    end
  end

end