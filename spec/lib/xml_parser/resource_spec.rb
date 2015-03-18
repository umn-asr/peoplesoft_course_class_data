require_relative '../../../lib/xml_parser/resource'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Resource do
  class PeoplesoftCourseClassData::XmlParser::Instructor < described_class
    def self.attributes
      [:name, :email]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes + child_collections)
  end

  # class PeoplesoftCourseClassData::XmlParser::Instructors < ResourceCollection

  class PeoplesoftCourseClassData::XmlParser::CombinedSection < described_class
    def self.attributes
      [:catalog_number]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  # class PeoplesoftCourseClassData::XmlParser::CombinedSections < ResourceCollection; end

  class PeoplesoftCourseClassData::XmlParser::Section < described_class
    def self.attributes
      [:class_number, :number, :component]
    end

    def self.child_collections
      [:instructors, :combined_sections]
    end

    configure_attributes(attributes + child_collections)
  end

  # class PeoplesoftCourseClassData::XmlParser::Sections < ResourceCollection; end


  class PeoplesoftCourseClassData::XmlParser::CleAttribute < described_class
    def self.attributes
      [:attribute_id, :family]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  # class PeoplesoftCourseClassData::XmlParser::CleAttributes < ResourceCollection; end

  class PeoplesoftCourseClassData::XmlParser::CourseAspect < described_class
    def self.attributes
      [:course_id, :catalog_number, :description, :title]
    end

    def self.child_collections
      [:sections, :cle_attributes]
    end

    configure_attributes(attributes + child_collections)
  end

  describe "#merge" do
    let(:jane)              { PeoplesoftCourseClassData::XmlParser::Instructor.new('Jane Schmoe', 'jane@umn.edu') }
    let(:joe)               { PeoplesoftCourseClassData::XmlParser::Instructor.new('Joe Schmoe', 'joe@umn.edu') }
    let(:combined_3456)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('3456') }
    let(:combined_5120)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('5120') }
    let(:jane_joe_lecture)  { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane, joe], [combined_5120]) }
    let(:jane_lab)          { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [jane], [combined_5120]) }
    let(:joe_lab)           { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [joe], [combined_5120]) }
    let(:jane_lecture)      { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane], [combined_3456]) }
    let(:joe_lecture)       { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [joe], [combined_3456]) }
    let(:writing_intensive) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('WI', 'CLE') }
    let(:phys_core)         { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('PHYS', 'CLE') }

    context "first level merge" do
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

    context "a nested merge" do
      let(:subject) {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [jane_joe_lecture, jane_lab],
                                                                              [writing_intensive]
                                                                            )
                                                                          }
      let(:other)   {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [joe_lab],
                                                                              [writing_intensive]
                                                                            )
                                                                          }

      it "navigates down the tree to perform a nested merge, adding joe as a lab instructor" do
        subject_lab = subject.sections.detect { |section| section == PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB") }
        expect(subject_lab.instructors).not_to include(joe)
        subject.merge(other)
        subject_lab = subject.sections.detect { |section| section == PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB") }
        expect(subject_lab.instructors).to include(joe)
      end
    end

    context "a merge on a second collection" do
      let(:subject) {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [jane_joe_lecture],
                                                                              [writing_intensive]
                                                                            )
                                                                          }
      let(:other)   {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [jane_joe_lecture],
                                                                              [phys_core]
                                                                            )
                                                                          }

      it "adds the new item to the collection" do
        expect(subject.cle_attributes).not_to include(phys_core)
        subject.merge(other)
        expect(subject.cle_attributes).to include(phys_core)
      end

      it "maintains the old items" do
        subject.merge(other)
        expect(subject.cle_attributes).to include(writing_intensive)
      end
    end
  end
end