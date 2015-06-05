require_relative '../../lib/merge_data'
require_relative '../../lib/xml_parser/course_aspect'

RSpec.describe PeoplesoftCourseClassData::MergeData do
  describe "#run" do
    let(:orchestrator) { instance_double("PeoplesoftCourseClassData::ClassJsonExport") }

    it "merges each collection of course aspects together" do
      COURSE_ID_1 = 1
      COURSE_ID_2 = 2

      collection_of_course_aspects = rand(5..10).times.map { PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_1) }
      another_collection_of_course_aspects = rand(5..10).times.map { PeoplesoftCourseClassData::XmlParser::CourseAspect.new(COURSE_ID_2) }

      collection_of_course_aspects[1..-1].each do |course_aspect|
        expect(collection_of_course_aspects.first).to receive(:merge).with(course_aspect).and_return(collection_of_course_aspects.first)
      end

      another_collection_of_course_aspects[1..-1].each do |course_aspect|
        expect(another_collection_of_course_aspects.first).to receive(:merge).with(course_aspect).and_return(another_collection_of_course_aspects.first)
      end

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::WriteData, [collection_of_course_aspects.first, another_collection_of_course_aspects.first])
      described_class.run([collection_of_course_aspects, another_collection_of_course_aspects], orchestrator)
    end
  end
end
