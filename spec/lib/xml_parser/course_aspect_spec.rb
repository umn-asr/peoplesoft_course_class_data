require_relative '../../../lib/xml_parser/course_aspect'

describe PeoplesoftCourseClassData::XmlParser::CourseAspect do
  describe ".type" do
    it "is 'course'" do
      expect(described_class.type).to eq('course')
    end
  end

  describe "==" do
    it "returns true if course_id is equal" do
      course1 = described_class.new({course_id: 1, course_title_long: "Long Title"})
      course2 = described_class.new({course_id: 1, description: "Description"})
      expect(course1 == course2).to be_truthy
    end

    it "returns false if the course_id is not equal" do
      course1 = described_class.new({course_id: 1, course_title_long: "Long Title"})
      course3 = described_class.new({course_id: 2, course_title_long: "Long Title"})
      expect(course1 == course3).to be_falsey
    end
  end
end
