require_relative '../../../lib/xml_parser/course_attribute'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseAttribute do

  describe ".type" do
    it "is 'attribute" do
      expect(described_class.type).to eq('attribute')
    end
  end

end