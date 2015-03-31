require_relative '../../../../lib/xml_parser/value/string'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::String do
  let(:string) { "a string" }
  subject { described_class.new(string) }
  describe "json_tree" do
    it "returns the original string" do
      expect(subject.json_tree).to eq(string)
    end
  end
end