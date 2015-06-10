RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::String do
  let(:string) { "a string" }
  subject { described_class.new(string) }
  describe "json_tree" do
    it "returns the original string" do
      expect(subject.json_tree).to eq(string)
    end

    it "makes sure the string has only ASCII characers" do
      non_ascii_string = "abc\u{6666}".force_encoding("UTF-8")
      expect(non_ascii_string.ascii_only?).to be_falsy

      expect(described_class.new(non_ascii_string).json_tree.ascii_only?).to be_truthy
    end
  end
end
