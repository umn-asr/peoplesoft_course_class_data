require_relative '../../../lib/qas/get_query_results'
require          'nokogiri'

RSpec.describe PeoplesoftCourseClassData::Qas::GetQueryResults do
  let(:soap_request_double)  { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }
  let(:query_instance) { SecureRandom.urlsafe_base64 }

  subject { PeoplesoftCourseClassData::Qas::GetQueryResults.new(soap_request_double, query_instance) }

  before do
    allow(subject).to receive(:sleep)
  end

  describe "#poll" do
    it "sends a soap request with 'QAS_GETQUERYRESULTS_OPER.VERSION_2' and a payload containing the first block of the query instance" do
      first_block_payload = block_payload(1, query_instance)
      expect(soap_request_double).to receive(:execute_request).with('QAS_GETQUERYRESULTS_OPER.VERSION_2', first_block_payload).and_return( queued_response)
      allow(soap_request_double).to receive(:execute_request).and_return(final_block_retrieved_response)
      subject.poll(&Proc.new {})
    end

    context "receives a 'queued' response" do
      before do
        allow(soap_request_double).to receive(:execute_request).and_return(queued_response, final_block_retrieved_response)
      end

      it "sleeps" do
        expect(subject).to receive(:sleep)

        subject.poll(&Proc.new {})
      end

      it "asks for the same block again" do
        first_block_payload = block_payload(1, query_instance)
        expect(soap_request_double).to receive(:execute_request).twice.with('QAS_GETQUERYRESULTS_OPER.VERSION_2', first_block_payload)

        subject.poll(&Proc.new {})
      end

      context "it keeps receiving 'queued'" do
        let(:maximum_attempts)  { rand(2..5) }

        subject { described_class.new(soap_request_double, query_instance, PeoplesoftCourseClassData::Qas::GetQueryResults::PollingConfiguration.new(maximum_attempts)) }

        it "will raise an error after the maximum number of attempts" do
          queued_data_responses = (maximum_attempts).times.map { queued_response }
          allow(soap_request_double).to receive(:execute_request).and_return(*queued_data_responses)
          expect{ |block| subject.poll(&block)}.to raise_error(PeoplesoftCourseClassData::Qas::GetQueryResults::MaximumAttemptsExceededError)
        end

        it "will not raise an error if data is retrieved before the maximum is exceeded" do
          responses_with_data = (maximum_attempts - 1).times.map { queued_response }
          responses_with_data << final_block_retrieved_response
          allow(soap_request_double).to receive(:execute_request).and_return(*responses_with_data)
          subject.poll(&Proc.new {})
        end

        it "a block retrieved response will the attempt count so no error is raised" do
          mixed_responses = (maximum_attempts - 1).times.map { queued_response }
          mixed_responses << block_retrieved_response
          mixed_responses << queued_response
          mixed_responses << final_block_retrieved_response

          expect(mixed_responses.count).to be > maximum_attempts #sanity check
          allow(soap_request_double).to receive(:execute_request).and_return(*mixed_responses)
          subject.poll(&Proc.new {})
        end
      end
    end

    context "recieves a 'blockRetrieved' response" do
      before do
        allow(soap_request_double).to receive(:execute_request).and_return(block_retrieved_response, final_block_retrieved_response)
      end

      it "asks for the next block of the response" do
        first_block_payload  = block_payload(1, query_instance)
        second_block_payload = block_payload(2, query_instance)
        expect(soap_request_double).to receive(:execute_request).with('QAS_GETQUERYRESULTS_OPER.VERSION_2', first_block_payload)
        expect(soap_request_double).to receive(:execute_request).with('QAS_GETQUERYRESULTS_OPER.VERSION_2', second_block_payload)

        subject.poll(&Proc.new {})
      end
    end

    context "receives 'finalBlockRetrieved" do
      before do
        allow(soap_request_double).to receive(:execute_request).and_return(final_block_retrieved_response)
      end

      it "breaks" do
        expect(soap_request_double).to receive(:execute_request).once

        subject.poll(&Proc.new {})
      end
    end

    context "receives an error" do
      before do
        allow(soap_request_double).to receive(:execute_request).and_return(error_response)
      end

      it "raises an SoapEnv error" do
        expect{ |block| subject.poll(&block)}.to raise_error(PeoplesoftCourseClassData::Qas::GetQueryResults::SoapEnvError)
      end
    end

    describe "yeilding the request results" do
      it "does not yield on queued responses, and yields once for each blockRetrieved and finalBlockRetrieved" do
        queued_responses                = rand(2..5).times.map { queued_response }
        block_retrieved_responses       = rand(1..5).times.map { block_retrieved_response }
        final_block_retrieved_responses = [final_block_retrieved_response]
        all_responses                   = queued_responses + block_retrieved_responses + final_block_retrieved_responses
        yieldable_responses             = block_retrieved_responses + final_block_retrieved_responses

        allow(soap_request_double).to receive(:execute_request).and_return(*all_responses)
        expect{ |block| subject.poll(&block) }.to yield_successive_args(*yieldable_responses)
      end
    end
  end

  def block_payload(block_number, query_instance)
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

  def queued_response
    response = <<-EOXML
      <?xml version="1.0" encoding="UTF-8"?>
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <soapenv:Body>
          <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
            <QAS_QUERYRESULTS_STATUS_RESP xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2">
              <status>queued</status>
            </QAS_QUERYRESULTS_STATUS_RESP>
          </QAS_GETQUERYRESULTS_RESP_MSG>
        </soapenv:Body>
      </soapenv:Envelope>
    EOXML
    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end

  def block_retrieved_response
    response = <<-EOXML
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Body>
        <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
          <query xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1" numrows="1845" queryname="UM_SR003_0021_CLASS_DATA">
            <row rownumber="1">
              <A.INSTITUTION><![CDATA[UMNTC]]></A.INSTITUTION>
              <A.CAMPUS><![CDATA[UMNTC]]></A.CAMPUS>
              <A.STRM><![CDATA[1149]]></A.STRM>
              <A.SESSION_CODE><![CDATA[001]]></A.SESSION_CODE>
              <A.SUBJECT><![CDATA[AAS]]></A.SUBJECT>
              <A.DESCR><![CDATA[Asian American Studies]]></A.DESCR>
              <A.CATALOG_NBR><![CDATA[1101]]></A.CATALOG_NBR>
              <A.CLASS_SECTION><![CDATA[003]]></A.CLASS_SECTION>
              <A.SSR_COMPONENT><![CDATA[DIS]]></A.SSR_COMPONENT>
              <A.DESCR1><![CDATA[Imagining Asian America]]></A.DESCR1>
              <A.CLASS_STAT><![CDATA[A]]></A.CLASS_STAT>
              <A.LOCATION><![CDATA[TCWESTBANK]]></A.LOCATION>
              <A.INSTRUCTION_MODE><![CDATA[P]]></A.INSTRUCTION_MODE>
              <A.DESCR2><![CDATA[Classroom/Onsite]]></A.DESCR2>
              <A.ENRL_CAP>28</A.ENRL_CAP>
              <A.ENRL_TOT>0</A.ENRL_TOT>
              <A.UNITS_MINIMUM>3</A.UNITS_MINIMUM>
              <A.UNITS_MAXIMUM>3</A.UNITS_MAXIMUM>
              <A.GRADING_BASIS><![CDATA[OPT]]></A.GRADING_BASIS>
              <A.XLATLONGNAME><![CDATA[Student Option]]></A.XLATLONGNAME>
              <A.CRS_TOPIC_ID>0</A.CRS_TOPIC_ID>
              <A.DESCRFORMAL/>
              <A.SCHEDULE_PRINT><![CDATA[Y]]></A.SCHEDULE_PRINT>
              <A.EQUIV_CRSE_ID/>
              <A.CRSE_REPEATABLE><![CDATA[N]]></A.CRSE_REPEATABLE>
              <A.UNITS_REPEAT_LIMIT>3</A.UNITS_REPEAT_LIMIT>
              <A.CRSE_REPEAT_LIMIT>1</A.CRSE_REPEAT_LIMIT>
              <A.CLASS_MTG_NBR>1</A.CLASS_MTG_NBR>
              <A.FACILITY_ID/>
              <A.MEETING_TIME_START> 9:05</A.MEETING_TIME_START>
              <A.MEETING_TIME_END> 9:55</A.MEETING_TIME_END>
              <A.MON/>
              <A.TUES/>
              <A.WED/>
              <A.UM_THURS/>
              <A.FRI><![CDATA[F]]></A.FRI>
              <A.SAT/>
              <A.UM_SUNDAY/>
              <A.START_DT>2014-09-02</A.START_DT>
              <A.END_DT>2014-12-10</A.END_DT>
              <A.INSTR_ASSIGN_SEQ>1</A.INSTR_ASSIGN_SEQ>
              <A.EMPLID><![CDATA[3620032]]></A.EMPLID>
              <A.INSTR_ROLE><![CDATA[PI]]></A.INSTR_ROLE>
              <A.SCHED_PRINT_INSTR><![CDATA[Y]]></A.SCHED_PRINT_INSTR>
              <A.CRSE_ATTR/>
              <A.CRSE_ATTR_VALUE/>
              <A.START_DT_CHN/>
              <A.END_DT_AFT/>
              <A.UM_ENRL_CAP2>0</A.UM_ENRL_CAP2>
              <A.RQRMNT_GROUP/>
              <A.CLASS_NOTES_SEQ>0</A.CLASS_NOTES_SEQ>
              <A.DESCR3/>
              <EXPR67_67/>
              <A.NAME_DISPLAY><![CDATA[Na-Rae Kim]]></A.NAME_DISPLAY>
              <A.EMAIL_ADDR><![CDATA[removeForDiscovery@email.com]]></A.EMAIL_ADDR>
              <EXPR1_1><![CDATA[Issues in Asian American Studies. Historical/recent aspects of the diverse/multifaceted vision of "Asian America," using histories, films, memoirs, and other texts as illustrations.]]></EXPR1_1>
              <A.SUBJECT_SRCH/>
              <A.CATALOG_NBR_SRCH/>
              <A.UM_CRSE_ATTR/>
              <A.UM_CRSE_ATT_VAL/>
              <A.DESCR50/>
              <A.COMBINED_SECTION/>
              <A.CLASS_NBR_CMBND>0</A.CLASS_NBR_CMBND>
              <A.SUBJECT_SRCH1/>
              <A.CATALOG_NBR_SRCH1/>
              <A.UM_CLASS_SECTION/>
              <A.CRSE_ID><![CDATA[797460]]></A.CRSE_ID>
              <A.CLASS_NBR>26550</A.CLASS_NBR>
              <A.CLASS_TYPE><![CDATA[E]]></A.CLASS_TYPE>
              <A.DESCRSHORT/>
            </row>
          </query>
          <QAS_QUERYRESULTS_STATUS_RESP xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2">
            <status>blockRetrieved</status>
          </QAS_QUERYRESULTS_STATUS_RESP>
        </QAS_GETQUERYRESULTS_RESP_MSG>
      </soapenv:Body>
    </soapenv:Envelope>
    EOXML
    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end

  def final_block_retrieved_response
    response = <<-EOXML
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Body>
        <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
          <query xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1" numrows="800" queryname="UM_SR003_0021_CLASS_DATA">
            <row rownumber="1">
              <A.INSTITUTION><![CDATA[UMNMO]]></A.INSTITUTION>
              <A.CAMPUS><![CDATA[UMNMO]]></A.CAMPUS>
              <A.STRM><![CDATA[1149]]></A.STRM>
              <A.SESSION_CODE><![CDATA[001]]></A.SESSION_CODE>
              <A.SUBJECT><![CDATA[AMIN]]></A.SUBJECT>
              <A.DESCR><![CDATA[American Indian Studies]]></A.DESCR>
              <A.CATALOG_NBR><![CDATA[1011]]></A.CATALOG_NBR>
              <A.CLASS_SECTION><![CDATA[001]]></A.CLASS_SECTION>
              <A.SSR_COMPONENT><![CDATA[DIS]]></A.SSR_COMPONENT>
              <A.DESCR1><![CDATA[Beginning Anishinaabe Lang I]]></A.DESCR1>
              <A.CLASS_STAT><![CDATA[A]]></A.CLASS_STAT>
              <A.LOCATION><![CDATA[MORRIS]]></A.LOCATION>
              <A.INSTRUCTION_MODE><![CDATA[P]]></A.INSTRUCTION_MODE>
              <A.DESCR2><![CDATA[In Person Term Based]]></A.DESCR2>
              <A.ENRL_CAP>25</A.ENRL_CAP>
              <A.ENRL_TOT>0</A.ENRL_TOT>
              <A.UNITS_MINIMUM>4</A.UNITS_MINIMUM>
              <A.UNITS_MAXIMUM>4</A.UNITS_MAXIMUM>
              <A.GRADING_BASIS><![CDATA[OPT]]></A.GRADING_BASIS>
              <A.XLATLONGNAME><![CDATA[Student Option]]></A.XLATLONGNAME>
              <A.CRS_TOPIC_ID>0</A.CRS_TOPIC_ID>
              <A.DESCRFORMAL/>
              <A.SCHEDULE_PRINT><![CDATA[Y]]></A.SCHEDULE_PRINT>
              <A.EQUIV_CRSE_ID/>
              <A.CRSE_REPEATABLE><![CDATA[N]]></A.CRSE_REPEATABLE>
              <A.UNITS_REPEAT_LIMIT>4</A.UNITS_REPEAT_LIMIT>
              <A.CRSE_REPEAT_LIMIT>1</A.CRSE_REPEAT_LIMIT>
              <A.CLASS_MTG_NBR>1</A.CLASS_MTG_NBR>
              <A.FACILITY_ID/>
              <A.MEETING_TIME_START>11:45</A.MEETING_TIME_START>
              <A.MEETING_TIME_END>12:50</A.MEETING_TIME_END>
              <A.MON><![CDATA[M]]></A.MON>
              <A.TUES/>
              <A.WED><![CDATA[W]]></A.WED>
              <A.UM_THURS/>
              <A.FRI><![CDATA[F]]></A.FRI>
              <A.SAT/>
              <A.UM_SUNDAY/>
              <A.START_DT>2014-08-27</A.START_DT>
              <A.END_DT>2014-12-12</A.END_DT>
              <A.INSTR_ASSIGN_SEQ>1</A.INSTR_ASSIGN_SEQ>
              <A.EMPLID><![CDATA[3318743]]></A.EMPLID>
              <A.INSTR_ROLE><![CDATA[PI]]></A.INSTR_ROLE>
              <A.SCHED_PRINT_INSTR><![CDATA[Y]]></A.SCHED_PRINT_INSTR>
              <A.CRSE_ATTR/>
              <A.CRSE_ATTR_VALUE/>
              <A.START_DT_CHN/>
              <A.END_DT_AFT/>
              <A.UM_ENRL_CAP2>0</A.UM_ENRL_CAP2>
              <A.RQRMNT_GROUP/>
              <A.CLASS_NOTES_SEQ>0</A.CLASS_NOTES_SEQ>
              <A.DESCR3/>
              <EXPR67_67/>
              <A.NAME_DISPLAY><![CDATA[Gabe Desrosiers]]></A.NAME_DISPLAY>
              <A.EMAIL_ADDR><![CDATA[removeForDiscovery@email.com]]></A.EMAIL_ADDR>
              <EXPR1_1><![CDATA[An introduction to speaking, writing, and reading Anishinaabe language and an overview of Anishinaabe culture.]]></EXPR1_1>
              <A.SUBJECT_SRCH/>
              <A.CATALOG_NBR_SRCH/>
              <A.UM_CRSE_ATTR/>
              <A.UM_CRSE_ATT_VAL/>
              <A.DESCR50/>
              <A.COMBINED_SECTION/>
              <A.CLASS_NBR_CMBND>0</A.CLASS_NBR_CMBND>
              <A.SUBJECT_SRCH1/>
              <A.CATALOG_NBR_SRCH1/>
              <A.UM_CLASS_SECTION/>
              <A.CRSE_ID><![CDATA[805389]]></A.CRSE_ID>
              <A.CLASS_NBR>33943</A.CLASS_NBR>
              <A.CLASS_TYPE><![CDATA[E]]></A.CLASS_TYPE>
              <A.DESCRSHORT/>
            </row>
          </query>
          <QAS_QUERYRESULTS_STATUS_RESP xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2">
            <status>finalBlockRetrieved</status>
          </QAS_QUERYRESULTS_STATUS_RESP>
        </QAS_GETQUERYRESULTS_RESP_MSG>
      </soapenv:Body>
    </soapenv:Envelope>
    EOXML
    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end

  def error_response
    response = <<-EOXML
    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
      <SOAP-ENV:Body>
        <SOAP-ENV:Fault>
          <faultcode>SOAP-ENV:Server</faultcode>
          <faultstring>null</faultstring>
          <detail>
            <IBResponse xmlns="" type="error">
              <DefaultTitle>Integration Broker Response</DefaultTitle>
              <StatusCode>20</StatusCode>
              <MessageID>5</MessageID>
              <DefaultMessage><![CDATA[XML parser error ParseXmlString Fatal Error: at file Integration Server  line: 5  column: 35  message: Expected end of tag 'data' (159,5)]]></DefaultMessage>
              <MessageParameters>
                <Parameter><![CDATA[ParseXmlString]]></Parameter>
                <Parameter><![CDATA[Fatal Error: at file Integration Server  line: 5  column: 35  message: Expected end of tag 'data']]></Parameter>
              </MessageParameters>
            </IBResponse>
          </detail>
        </SOAP-ENV:Fault>
      </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
    EOXML
    response = Nokogiri.XML(response) do |config|
      config.default_xml.noblanks
    end
    response
  end
end