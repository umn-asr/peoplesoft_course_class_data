RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseAttribute do

  describe ".type" do
    it "is 'attribute" do
      expect(described_class.type).to eq('attribute')
    end
  end

end
