require_relative '../../../lib/xml_parser/course_aspect'

RSpec.describe PeoplesoftCourseClassData::XmlParser::CourseAspect do
  describe "merge" do
    context "a nested merge" do
      let(:jane)              { PeoplesoftCourseClassData::XmlParser::Instructor.new('Jane Schmoe', 'jane@umn.edu') }
      let(:joe)               { PeoplesoftCourseClassData::XmlParser::Instructor.new('Joe Schmoe', 'joe@umn.edu') }
      let(:combined_3456)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('3456') }
      let(:combined_5120)     { PeoplesoftCourseClassData::XmlParser::CombinedSection.new('5120') }
      let(:jane_joe_lecture)  { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "001", "LEC", [jane, joe], [combined_5120]) }
      let(:jane_lab)          { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [jane], [combined_5120]) }
      let(:joe_lab)           { PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB", [joe], [combined_5120]) }

      let(:writing_intensive) { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('WI', 'CLE') }
      let(:phys_core)         { PeoplesoftCourseClassData::XmlParser::CleAttribute.new('PHYS', 'CLE') }


      let(:subject) {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [jane_joe_lecture, jane_lab], [writing_intensive]
                                                                            )
                                                                          }
      let(:other)   {
                      PeoplesoftCourseClassData::XmlParser::CourseAspect.new(
                                                                              "002066", "1101W", "description", "Intro College Phys I",
                                                                              [joe_lab], [writing_intensive]
                                                                            )
                                                                          }

      it "navigates down the tree to perform a nested merge, adding joe as a lab instructor" do
        lab_section = subject.sections.detect { |section| section == PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB") }
        expect(lab_section.instructors).not_to include(joe)
        subject.merge(other)
        lab_section = subject.sections.detect { |section| section == PeoplesoftCourseClassData::XmlParser::Section.new("26191", "002", "LAB") }
        expect(lab_section.instructors).to include(joe)
      end
    end
  end
end