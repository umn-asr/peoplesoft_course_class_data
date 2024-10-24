module PeoplesoftCourseClassData
  class ClassService
    def initialize(soap_request, query_runner = nil)
      self.soap_request = soap_request
      self.query_runner = query_runner || PeoplesoftCourseClassData::Qas::QueryWithPolledResponse.new(soap_request)
    end

    def query(institution, campus, term, &)
      query_runner.run(query_content(institution, campus, term), &)
    end

    private

    attr_accessor :soap_request, :query_runner

    def query_content(institution, campus, term)
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
end
