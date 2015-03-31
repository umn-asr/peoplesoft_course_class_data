require_relative '../../../../lib/xml_parser/value/integer'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::Integer do
  let(:integer) { rand(1..999_999) }
  subject { described_class.new(integer) }
  describe "json_tree" do
    it "returns a string version of the integer" do
      expect(subject.json_tree).to eq(integer.to_s)
    end
  end
end