require_relative '../../../lib/xml_parser/course_aspect'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseAspect do
  describe "#merge" do
    let(:jane)              { PeoplesoftCourseClassData::XmlParser::Instructor.new('Jane Schmoe', 'jane@umn.edu') }
    let(:joe)               { PeoplesoftCourseClassData::XmlParser::Instructor.new('Joe Schmoe', 'joe@umn.edu') }
    let(:combined_3456)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('3456') }
    let(:combined_5120)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('5120') }
    let(:jane_joe_lecture)  { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane, joe], [combined_5120]) }
    let(:jane_lab)          { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [jane], [combined_5120]) }
    let(:joe_lab)           { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [joe], [combined_5120]) }
    let(:writing_intensive) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('WI', 'CLE') }
    let(:phys_core)         { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('PHYS', 'CLE') }

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