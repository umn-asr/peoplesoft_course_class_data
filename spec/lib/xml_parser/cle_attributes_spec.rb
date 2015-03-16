require_relative '../../../lib/xml_parser/cle_attributes'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CleAttributes do
  let(:writing_intensive) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('WI', 'CLE') }
  let(:phys_core) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('PHYS', 'CLE') }

  subject { described_class.new([writing_intensive]) }

  describe "#merge" do
    let(:other) { described_class.new([phys_core]) }
    it "returns an instance of CleAttributes" do
      expect(subject.merge(other)).to be_instance_of(described_class)
    end

    describe "when other's attributes are the same" do
      let(:other) { described_class.new([writing_intensive]) }

      it "is equal to the original" do
        original = subject
        subject.merge(other)
        expect(subject).to eq(original)
      end
    end

    describe "when the other's members are not the same" do

      let(:other)     { described_class.new([phys_core]) }
      it "adds them to the cle_attributes" do
        subject.merge(other)
        expect(subject).to include(phys_core)
      end
      it "leaves the original unchanged" do
        original = subject
        merged = subject.merge(other)
        expect(merged).not_to eq(original)
        expect(subject).to eq(original)
      end
    end
  end
end