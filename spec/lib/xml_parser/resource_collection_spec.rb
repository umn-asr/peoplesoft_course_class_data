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

  let(:wi) { PeoplesoftCourseClassData::XmlParser::Value::String.new('WI') }
  let(:cle) { PeoplesoftCourseClassData::XmlParser::Value::String.new('CLE') }
  let(:phys) { PeoplesoftCourseClassData::XmlParser::Value::String.new('PHYS') }
  let(:writing_intensive) { TestCleAttribute.new(attribute_id: wi, family: cle) }
  let(:phys_core)         { TestCleAttribute.new(attribute_id: phys, family: cle) }

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

    context "with nil" do
      subject { described_class.new(nil) }

      it "adds nothing to the collection" do
        expect(subject).to be_empty
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

  describe "#json_tree" do
    subject { described_class.new([writing_intensive, phys_core]) }
    it "is an array" do
      expect(subject.json_tree).to be_kind_of(Array)
    end

    it "hash a json representation of each member of the collection" do
      expect(subject.json_tree).to eq([writing_intensive, phys_core].map(&:json_tree))
    end
  end
end
