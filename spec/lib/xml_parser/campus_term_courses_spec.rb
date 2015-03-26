require_relative '../../../lib/xml_parser/campus_term_courses'
require_relative '../../../lib/xml_parser/term'
require_relative '../../../lib/xml_parser/campus'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CampusTermCourses do
  describe "to_json" do
    subject { subject_instance = described_class.new(PeoplesoftCourseClassData::XmlParser::Campus.new, PeoplesoftCourseClassData::XmlParser::Term.new, []) }
    it "does not have a type key" do
      actual_key_value_pairs = key_value_pairs(subject.to_json)
      campus_term_course_type = key_value_pairs({'type' => described_class.type}.to_json)

      expect(actual_key_value_pairs).not_to include(campus_term_course_type)
    end

    it "does have a type keys for children" do
      actual_key_value_pairs = key_value_pairs(subject.to_json)

      [PeoplesoftCourseClassData::XmlParser::Campus, PeoplesoftCourseClassData::XmlParser::Term].each do |child_resource|
        child_type_key_value_pair = key_value_pairs({'type' => child_resource.type}.to_json)
        expect(actual_key_value_pairs).to include(child_type_key_value_pair)
      end
    end


    def key_value_pairs(json_string)
      json_string.gsub(/\{|\}/,'')
    end
  end
end