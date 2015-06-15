RSpec.describe PeoplesoftCourseClassData::SortData do
  describe "#run" do
    it "returns collections of items with the same course_id" do
      orchestrator = instance_double("PeoplesoftCourseClassData::QueryResults")

      course_ids = (1..rand(3..5)).to_a
      class_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "class_catalog_#{i}") }
      course_data = 10.times.map { |i| PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: course_ids.sample, catalog_number: "course_catalog_#{i}") }
      parsed_data = [class_data, course_data]

      expected = Array.new

      grouping = instance_double("PeoplesoftCourseClassData::Grouping")
      allow(PeoplesoftCourseClassData::Grouping).to receive(:group).with(parsed_data).and_return(grouping)
      allow(grouping).to receive(:by).with(:course_id).and_return(expected)

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::MergeData, expected)
      described_class.run(parsed_data, orchestrator)
    end
  end
end
