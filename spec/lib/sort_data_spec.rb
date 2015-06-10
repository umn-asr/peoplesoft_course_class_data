RSpec.describe PeoplesoftCourseClassData::SortData do
  describe "#run" do
    it "returns collections of items with the same course_id" do
      orchestrator = instance_double("PeoplesoftCourseClassData::QueryResults")

      course_ids = (1..rand(3..5)).to_a
      class_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "class_catalog_#{i}") }
      course_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "course_catalog_#{i}") }

      expected = course_ids.map do |id|
        matched_course_aspects = class_data.select{ |course_aspect| course_aspect.course_id == id}
        matched_course_aspects << course_data.select{ |course_aspect| course_aspect.course_id == id}
        matched_course_aspects.flatten
      end

      expected.reject! { |course_collection| course_collection.empty? }

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::MergeData, expected)
      described_class.run([class_data, course_data], orchestrator)
    end
  end
end
