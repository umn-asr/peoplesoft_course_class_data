RSpec.describe PeoplesoftCourseClassData::XmlParser::Row do
  let(:namespace)   { 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1' }
  let(:row_nodeset) { row(nodeset) }
  subject { InheritsFromRow.new(row_nodeset, namespace) }

  describe "gerenated methods" do
    it "adds an accessor for each key in the supplied hash" do
      InheritsFromRow::ROW_ATTRIBUTES.keys.each do |key|
        expect(subject).to respond_to(key)
      end
    end

    it "gets the associated value from the xml file" do
      expect(subject.course__course_id).to eq('795342')
    end

    context "when no type is specified" do
      it "returns a string value" do
        expect(subject.course__course_id).to be_kind_of(PeoplesoftCourseClassData::XmlParser::Value::String)
      end
    end

    context "when a type is specified" do
      it "coverts the data to the specified type" do
        expect(subject.course__enrollment_cap).to be_kind_of(PeoplesoftCourseClassData::XmlParser::Value::Integer)
        expect(subject.course__section__credits_maximum).to be_kind_of(PeoplesoftCourseClassData::XmlParser::Value::Float)
      end
    end

    context "when the row is from a document with multiple rows" do
      subject { InheritsFromRow.new(row(multi_row_node_set), namespace) }

      it "only returns the data for the supplied row, i.e don't use //ns:key in Row to find the values" do
        expect(subject.course__course_id).to eq('795342')
      end
    end
  end

  class InheritsFromRow < PeoplesoftCourseClassData::XmlParser::Row
    ROW_ATTRIBUTES = {
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

    ROW_ATTRIBUTES.each do | method_name, config |
      define_method(method_name) do
        self.send type_conversion(config), xml_value(config)
      end
    end
  end

  def row(xml_string)
    full_nodeset = PeoplesoftCourseClassData::XmlParser::NodeSet.build(xml_string)
    full_nodeset.xpath('//ns:row', 'ns' => namespace).first
  end

  def nodeset
    xml = <<-EOXML
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Body>
        <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
          <query xmlns="#{namespace}" numrows="800" queryname="UM_SR003_0021_CLASS_DATA">
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
  end

  def multi_row_node_set
    xml = <<-EOXML
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Body>
        <QAS_GETQUERYRESULTS_RESP_MSG xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_GETQUERYRESULTS_RESP_MSG.VERSION_2">
          <query xmlns="#{namespace}" numrows="800" queryname="UM_SR003_0021_CLASS_DATA">
            <row rownumber="1">
              <A.CRSE_ID><![CDATA[795342]]></A.CRSE_ID>
              <A.CATALOG_NBR><![CDATA[3120]]></A.CATALOG_NBR>
              <A.UNITS_MAXIMUM>3.5</A.UNITS_MAXIMUM>
              <A.ENRL_CAP>25</A.ENRL_CAP>
            </row>
            <row rownumber="2">
              <A.CRSE_ID><![CDATA[54321]]></A.CRSE_ID>
              <A.CATALOG_NBR><![CDATA[1234]]></A.CATALOG_NBR>
              <A.UNITS_MAXIMUM>2</A.UNITS_MAXIMUM>
              <A.ENRL_CAP>42</A.ENRL_CAP>
            </row>
          </query>
          <QAS_QUERYRESULTS_STATUS_RESP xmlns="http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_STATUS_RESP.VERSION_2">
            <status>finalBlockRetrieved</status>
          </QAS_QUERYRESULTS_STATUS_RESP>
        </QAS_GETQUERYRESULTS_RESP_MSG>
      </soapenv:Body>
    </soapenv:Envelope>

          EOXML
  end
end
