require_relative '../../../config/file_root'

require_relative '../../../lib/xml_parser/course_json'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseJson do
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }

  let(:service)       { PeoplesoftCourseClassData::CourseService }
  let(:query_config)  { PeoplesoftCourseClassData::QueryConfig.new(:tst, {institution: 'UMNTC', campus: 'UMNTC', term: '1149'}) }
  let(:data_source)   { PeoplesoftCourseClassData::DataSource.build(service, query_config) }

  describe "parse" do
    it "returns the expected json" do
      data_source_data = "<course_service_data>"
      data_source_data += File.read("#{fixture_directory}/reference_courses.xml")
      data_source_data += "</course_service_data>"

      allow(data_source).to receive(:data).and_return(data_source_data)
      allow(data_source).to receive(:campus).and_return("UMNTC")
      allow(data_source).to receive(:term).and_return("1149")

      results = described_class.parse(data_source)
      expected_json = "{\"campus\":{\"type\":\"campus\",\"campus_id\":\"UMNTC\",\"abbreviation\":\"UMNTC\"},\"term\":{\"type\":\"term\",\"term_id\":\"1149\",\"strm\":\"1149\"},\"courses\":[{\"type\":\"course\",\"course_id\":\"\",\"course_title_long\":\"Social and Intellectual Movements in the African Diaspora\",\"offer_frequency\":\"Every Fall\",\"course_attributes\":[],\"sections\":[]},{\"type\":\"course\",\"course_id\":\"\",\"course_title_long\":\"Introductory College Physics I\",\"offer_frequency\":\"Every Fall, Spring & Summer\",\"course_attributes\":[],\"sections\":[]}]}"
      expect(results).to eq(expected_json)
    end
  end
end
