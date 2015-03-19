require_relative '../../../lib/xml_parser/resource'
require_relative '../../../lib/xml_parser/resource_collection'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ResourceCollection do

  class TestCleAttribute < PeoplesoftCourseClassData::XmlParser::Resource
    def self.attributes
      [:attribute_id, :family]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  let(:writing_intensive) { TestCleAttribute.new('WI', 'CLE') }
  let(:phys_core)         { TestCleAttribute.new('PHYS', 'CLE') }

  describe "new" do
    context "with a collection" do
      subject { described_class.new([writing_intensive, phys_core]) }

      it "adds all objects to the collection" do
        [writing_intensive, phys_core].each do |item|
          expect(subject).to include(item)
        end
      end
    end

    context "with a single object" do
      subject { described_class.new(writing_intensive) }

      it "adds the single object to its collection" do
        expect(subject).to include(writing_intensive)
      end
    end
  end

  describe "#merge" do
    subject { described_class.new([writing_intensive]) }

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