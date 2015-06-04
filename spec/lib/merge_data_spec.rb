require_relative '../../lib/merge_data'
require_relative '../../lib/xml_parser/course_aspect'

RSpec.describe PeoplesoftCourseClassData::MergeData do
  describe "#run" do
    let(:orchestrator) { instance_double("PeoplesoftCourseClassData::ClassJsonExport") }

    it "merges course aspects with the same course_id together" do
      COURSE_ID_1 = 1
      course_1_aspect_1 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      course_1_aspect_2 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      course_1_aspect_3 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      course_1_aspect_4 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)
      course_1_aspect_5 = PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1)

      collection_of_course_aspects = [course_1_aspect_1, course_1_aspect_2, course_1_aspect_3]
      another_collection_of_course_aspects = [course_1_aspect_4, course_1_aspect_5]

      collection_of_course_aspects[1..-1].each do |ca|
        expect(collection_of_course_aspects[0]).to receive(:merge).with(ca).and_return(collection_of_course_aspects[0])
        described_class.run([collection_of_course_aspects[0], ca], orchestrator)
      end

      another_collection_of_course_aspects[1..-1].each do |ca|
        expect(another_collection_of_course_aspects[0]).to receive(:merge).with(ca).and_return(another_collection_of_course_aspects[0])
        described_class.run([another_collection_of_course_aspects[0], ca], orchestrator)
      end

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::WriteData, course_1_aspect_1)
    end
  end
end
