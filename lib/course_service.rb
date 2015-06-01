require_relative 'qas/qas'

module PeoplesoftCourseClassData
  class CourseService
    def initialize(soap_request, query_runner = nil)
      self.soap_request = soap_request
      self.query_runner = query_runner || PeoplesoftCourseClassData::Qas::QueryWithPolledResponse.new(soap_request)
    end

    def query(institution, campus, term, &block)
      query_runner.run(query_content(institution, campus, term), &block)
    end

    private
    attr_accessor :soap_request, :query_runner

    def query_content(institution, campus, term)
      <<-EOXML
          <qas:QAS_EXEQRYSYNCPOLL_REQ_MSG>
             <qas1:QAS_EXEQRYSYNCPOLL_REQ>
                <QueryName>UMSR_ECAS_COURSE_CATALOG_QRY</QueryName>
                <isConnectedQuery>N</isConnectedQuery>
                <OwnerType>PUBLIC</OwnerType>
                <BlockSizeKB>0</BlockSizeKB>
                <MaxRow>0</MaxRow>
                <OutResultType>XMLP</OutResultType>
                <OutResultFormat>NONFILE</OutResultFormat>
                <Prompts>
                   <PROMPT>
                      <PSQueryName>UMSR_ECAS_COURSE_CATALOG_QRY</PSQueryName>
                      <UniquePromptName>INSTITUTION</UniquePromptName>
                      <FieldValue>#{institution}</FieldValue>
                   </PROMPT>
                   <PROMPT>
                      <PSQueryName>UMSR_ECAS_COURSE_CATALOG_QRY</PSQueryName>
                      <UniquePromptName>CAMPUS</UniquePromptName>
                      <FieldValue>#{campus}</FieldValue>
                   </PROMPT>
                   <PROMPT>
                      <PSQueryName>UMSR_ECAS_COURSE_CATALOG_QRY</PSQueryName>
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
