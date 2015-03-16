require_relative '../../../lib/xml_parser/cle_attribute'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CleAttribute do
  subject { described_class.new('WI', 'CLE') }

  describe "equality" do
    context "when the other CleAttribute has the same attribute_id and family" do
      let(:other) { described_class.new('WI', 'CLE') }

      it "is not equal" do
        expect(subject).to eq(other)
      end
    end

    context "when the other CleAttribute has a different attribute_id" do
      let(:other) { described_class.new('PHYS', 'CLE') }

      it "is not equal" do
        expect(subject).not_to eq(other)
      end
    end

    context "when the other CleAttribute has a different family" do
      let(:other) { described_class.new('WI', 'CVG') }

      it "is not equal" do
        expect(subject).not_to eq(other)
      end
    end
  end
end