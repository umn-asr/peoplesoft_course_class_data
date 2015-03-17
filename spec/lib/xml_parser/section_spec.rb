require_relative '../../../lib/xml_parser/section'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Section do
  describe "equality" do
    subject { described_class.new("26191", "001", "LEC") }
    context "class_number, number, and component match" do
      let(:other) { described_class.new("26191", "001", "LEC") }
      it "is equal to the other" do
        expect(subject).to eq(other)
      end
    end

    context "an attribute mismatch" do
      let(:other_class_number)  { described_class.new("26193", "001", "LEC") }
      let(:other_number)       { described_class.new("26192", "002", "LEC") }
      let(:other_component)     { described_class.new("26192", "001", "LAB") }
      it "is not equal" do
        [other_class_number, other_number, other_component].each do |other|
          expect(subject).not_to eq(other)
        end
      end
    end
  end

  describe "#merge" do
    let(:jane)          { PeoplesoftCourseClassData::XmlParser::Instructor.new('Jane Schmoe', 'jane@umn.edu') }
    let(:joe)           { PeoplesoftCourseClassData::XmlParser::Instructor.new('Joe Schmoe', 'joe@umn.edu') }
    let(:combined_3456) { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('3456') }
    let(:combined_5120) { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('5120') }
    let(:jane_lecture)  { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane], [combined_3456]) }
    let(:joe_lecture)   { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [joe], [combined_3456]) }

    subject { jane_lecture }

    context "when the other is not equal" do
      let(:lab)           { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [jane], [combined_3456]) }

      it "returns self" do
        expect(subject.merge(lab)).to eq(subject)
      end
    end

    context "when the other is equal" do
      context "and the other's instructor is not in the subject's collection" do
        let(:other) { joe_lecture }

        it "adds the other's instructor to the collection" do
          subject.merge(other)
          expect(subject.instructors).to include(joe)
        end

        it "leaves the combined_sections alone" do
          original_combined_sections = subject.combined_sections
          subject.merge(other)
          expect(subject.combined_sections.count).to eq(original_combined_sections.count)
          expect(subject.combined_sections).to eq(original_combined_sections)
        end
      end

      context "and the other's combined section is not in the subject's collection" do
        let (:other) { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane], [combined_5120]) }

        it "adds the other's combined section to the collection" do
          subject.merge(other)
          expect(subject.combined_sections).to include(combined_5120)
        end

        it "leaves the instructors unchanged" do
          original_instructors = subject.instructors
          subject.merge(other)
          expect(subject.instructors.count).to eq(original_instructors.count)
          expect(subject.instructors).to eq(original_instructors)
        end
      end

      context "and the other's child is in the subject's collection" do
        let(:instructor_spy) { instance_spy("Instructor", name: "Jane Schmoe", email: "jane@umn.edu") }
        let(:other) { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [instructor_spy], [combined_5120]) }
        subject { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [instructor_spy], [combined_5120]) }

        it "merges its child with the other's child. using spies because Rspec arg matchers do not like us overwriting == " do
          subject_jane  = subject.instructors.detect { |instructor| instructor.name == "Jane Schmoe" }
          other_jane    = other.instructors.detect { |instructor| instructor.name == "Jane Schmoe" }
          subject.merge(other)
          expect(subject_jane).to have_received(:merge).with(other_jane)
        end
      end
    end
  end
end