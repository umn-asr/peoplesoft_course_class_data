require_relative '../../lib/merge_data'
require_relative '../../lib/xml_parser/course_aspect'

RSpec.describe PeoplesoftCourseClassData::MergeData, :focus do
  describe "#run" do
    let(:orchestrator) { instance_double("PeoplesoftCourseClassData::ClassJsonExport") }

    it "merges course aspects with the same course_id together" do
      COURSE_ID_1 = 1
      class_course_aspect_1 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      class_course_aspect_2 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      course_course_aspect_1 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)

      class_service_results = [class_course_aspect_1, class_course_aspect_2]
      course_service_results = [course_course_aspect_1]

      expect(class_course_aspect_1).to receive(:merge).with(class_course_aspect_2).and_return(class_course_aspect_1)
      expect(class_course_aspect_1).to receive(:merge).with(course_course_aspect_1).and_return(class_course_aspect_1)

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::WriteData, class_course_aspect_1)
      described_class.run([class_service_results, course_service_results], orchestrator)
    end
  end
end
