require_relative '../../../lib/xml_parser/cle_attribute'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CleAttribute do

  describe ".type" do
    it "is 'attribute" do
      expect(described_class.type).to eq('attribute')
    end
  end

end