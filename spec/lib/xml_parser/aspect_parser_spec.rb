RSpec.describe PeoplesoftCourseClassData::XmlParser::AspectParser do
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }

  describe "parse" do
    it "returns a collection of Course Aspects" do
      data_source_data = "<course_service_data>"
      data_source_data += File.read("#{fixture_directory}/reference_classes.xml")
      data_source_data += "</course_service_data>"

      node_set = PeoplesoftCourseClassData::XmlParser::NodeSet.build(data_source_data)

      row_parser_double = class_double("PeoplesoftCourseClassData::XmlParser::ClassRows")
      parsed_rows_double = instance_double("PeoplesoftCourseClassData::XmlParser::ClassRows")
      rows_double = [Object.new]
      allow(row_parser_double).to receive(:new).and_return(parsed_rows_double)
      allow(parsed_rows_double).to receive(:rows).and_return(rows_double)

      course_aspect_double = instance_double("PeoplesoftCourseClassData::XmlParser::CourseAspect")

      expect(PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder).to receive(:build_from_row).with(rows_double.first).and_return(course_aspect_double)

      results = described_class.parse(node_set, row_parser_double)
      expect(results).to eq([course_aspect_double])
    end
  end
end
