require_relative '../../../lib/xml_parser/parsed_row'
# require_relative '../../../lib/xml_parser/xml_parser'
require 'nokogiri'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ParsedRow do
  subject { InheritsFromParsedRow.new(node_set) }
  describe "configure" do
    it "adds an accessor for each key in the supplied hash" do
      InheritsFromParsedRow::ROW_MAPPING.keys.each do |key|
        expect(subject).to respond_to(key)
      end
    end

    it "gets the associated value from the xml file" do
      expect(subject.course__course_id).to eq('795342')
    end

    context "when no type is specified" do
      it "returns a string" do
        expect(subject.course__course_id).to be_kind_of(String)
      end
    end

    context "when a type is specified" do
      it "coverts the data to the specified type" do
        expect(subject.course__enrollment_cap).to be_kind_of(Integer)
        expect(subject.course__section__credits_maximum).to be_kind_of(Float)
      end
    end

    context "namespaced elements" do
      let(:namespace) { 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1' }
      subject { InheritsFromParsedRow.new(namespaced_node_set, namespace) }

      it "finds namespaces elements if the NAMESPACE is set" do
        expect(subject.course__course_id).to eq('795342')
      end
    end
  end

  class InheritsFromParsedRow < PeoplesoftCourseClassData::XmlParser::ParsedRow
    ROW_MAPPING = {
                    course__course_id: {
                      xml_field:  'A.CRSE_ID'
                    },
                    course__enrollment_cap: {
                      xml_field:  'A.ENRL_CAP',
                      type:       'integer'
                    },
                    course__section__credits_maximum: {
                      xml_field:  'A.UNITS_MAXIMUM',
                      type:       'float'
                    }
                  }

    configure
  end

  def node_set
    xml = <<-EOXML
          <my_xml>
            <A.CRSE_ID><![CDATA[795342]]></A.CRSE_ID>
            <A.CATALOG_NBR><![CDATA[3120]]></A.CATALOG_NBR>
            <A.UNITS_MAXIMUM>3.5</A.UNITS_MAXIMUM>
            <A.ENRL_CAP>25</A.ENRL_CAP>
            </my_xml>
          EOXML
    nokogiri_doc = Nokogiri::XML(xml) do |config|
      config.default_xml.noblanks
    end
    nokogiri_doc
  end

  def namespaced_node_set
    xml = <<-EOXML
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Body>
        <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
          <query xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1" numrows="800" queryname="UM_SR003_0021_CLASS_DATA">
            <row rownumber="1">
                    <A.CRSE_ID><![CDATA[795342]]></A.CRSE_ID>
                    <A.CATALOG_NBR><![CDATA[3120]]></A.CATALOG_NBR>
                    <A.UNITS_MAXIMUM>3.5</A.UNITS_MAXIMUM>
                    <A.ENRL_CAP>25</A.ENRL_CAP>
            </row>
          </query>
          <QAS_QUERYRESULTS_STATUS_RESP xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2">
            <status>finalBlockRetrieved</status>
          </QAS_QUERYRESULTS_STATUS_RESP>
        </QAS_GETQUERYRESULTS_RESP_MSG>
      </soapenv:Body>
    </soapenv:Envelope>

          EOXML
    nokogiri_doc = Nokogiri::XML(xml) do |config|
      config.default_xml.noblanks
    end
    nokogiri_doc
  end
end
