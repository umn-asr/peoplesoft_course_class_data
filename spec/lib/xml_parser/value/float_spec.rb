RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::Float do
  let(:float) { rand(1.1..999.9) }
  subject { described_class.new(float) }

  describe "json_tree" do
    it "returns a string version of the float" do
      expect(subject.json_tree).to eq(float.to_s)
    end

    context "when the float end in .0" do
      let(:whole_number) { rand(1..999) }
      let(:whole_float) { Float(whole_number) }
      subject { described_class.new(whole_float) }

      it "does not contain the .0" do
        expect(subject.json_tree).to eq(whole_number.to_s)
      end
    end
  end
end
