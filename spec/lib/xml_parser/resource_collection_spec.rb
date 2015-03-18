require_relative '../../../lib/xml_parser/resource'
require_relative '../../../lib/xml_parser/resource_collection'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ResourceCollection do

  class PeoplesoftCourseClassData::XmlParser::CleAttribute < PeoplesoftCourseClassData::XmlParser::Resource
    def self.attributes
      [:attribute_id, :family]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  let(:writing_intensive) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('WI', 'CLE') }
  let(:phys_core)         { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('PHYS', 'CLE') }

  subject { described_class.new([writing_intensive]) }

  describe "#merge" do
    let(:other) { described_class.new([phys_core]) }

    context "when other's attributes are the same" do
      let(:other) { described_class.new([writing_intensive]) }

      it "is equal to the original" do
        original = subject
        subject.merge(other)
        expect(subject).to eq(original)
      end
    end

    context "when the other's members are not the same" do

      let(:other)     { described_class.new([phys_core]) }
      it "adds them to the cle_attributes" do
        subject.merge(other)
        expect(subject).to include(phys_core)
      end
    end
  end
end