RSpec.describe PeoplesoftCourseClassData::ClassService do
  describe "query" do
    let(:args)                { ["FOO", "BAR", 1234] }
    let(:soaprequest_double)  { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }
    let(:qas_query_double)    { instance_double("PeoplesoftCourseClassData::Qas::QueryWithPolledResponse") }

    it "builds a query using the parameters" do
      expect(qas_query_double).to receive(:run).with(query_template(*args))
      PeoplesoftCourseClassData::ClassService.new(soaprequest_double, qas_query_double).query(*args)
    end

    it "uses PeoplesoftCourseClassData::Qas::QueryWithPolledResponse if no query runner is supplied" do
      expect(PeoplesoftCourseClassData::Qas::QueryWithPolledResponse).to receive(:new).with(soaprequest_double) { qas_query_double }
      expect(qas_query_double).to receive(:run).with(query_template(*args))

      PeoplesoftCourseClassData::ClassService.new(soaprequest_double).query(*args)
    end
  end

  def query_template(institution, campus, term)
      <<-EOXML
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
  end
end
