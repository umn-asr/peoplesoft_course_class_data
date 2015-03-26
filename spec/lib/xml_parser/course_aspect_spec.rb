require_relative '../../../lib/xml_parser/course_aspect'

describe PeoplesoftCourseClassData::XmlParser::CourseAspect do
  describe ".type" do
    it "is 'course'" do
      expect(described_class.type).to eq('course')
    end
  end
end