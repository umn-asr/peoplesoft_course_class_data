require_relative '../../lib/sort_data'

RSpec.describe PeoplesoftCourseClassData::SortData do
  describe "#run" do
    it "returns collections of items with the same course_id" do
      orchestrator = instance_double("PeoplesoftCourseClassData::QueryResults")

      course_ids = (1..rand(3..5)).to_a
      class_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "class_catalog_#{i}") }
      course_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "course_catalog_#{i}") }

      classified_data = [class_data, course_data].flatten.to_set.classify { |course_aspect| course_aspect.course_id }
      expected = classified_data.values

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::MergeData, expected)
      described_class.run([class_data, course_data], orchestrator)
    end
  end
end
