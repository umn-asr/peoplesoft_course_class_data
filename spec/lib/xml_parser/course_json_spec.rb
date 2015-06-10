require_relative '../../../config/file_root'

require_relative '../../../lib/xml_parser/course_json'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseJson do
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }

  describe "parse" do
    it "returns a collection of Course Aspects" do
      data_source_data = "<course_service_data>"
      data_source_data += File.read("#{fixture_directory}/reference_courses.xml")
      data_source_data += "</course_service_data>"

      node_set = PeoplesoftCourseClassData::XmlParser::NodeSet.build(data_source_data)

      course_rows_double = instance_double("PeoplesoftCourseClassData::XmlParser::CourseRows")
      expect(PeoplesoftCourseClassData::XmlParser::CourseRows).to receive(:new).with(node_set).and_return(course_rows_double)

      rows_double = []
      rows_double << instance_double("PeoplesoftCourseClassData::XmlParser::CourseRow")

      expect(course_rows_double).to receive(:rows).and_return(rows_double)

      course_aspect_double = instance_double("PeoplesoftCourseClassData::XmlParser::CourseAspect")

      expect(PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder).to receive(:build_from_row).with(rows_double.first).and_return(course_aspect_double)

      results = described_class.parse(node_set)
      expect(results).to eq([course_aspect_double])
    end
  end
end
