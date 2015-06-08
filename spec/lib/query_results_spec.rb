require_relative '../../lib/query_results'

RSpec.describe PeoplesoftCourseClassData::QueryResults do
  let(:query_config) { instance_double("PeoplesoftCourseClassData::QueryConfig", campus: 'UMNTC', term: '1149', env: :tst) }
  subject { described_class.new(query_config) }

  describe "class.as_json" do
    it "Creates an instance and calls its as_json method" do
      expected = "Results"
      results_double = instance_double("PeoplesoftCourseClassData::QueryResults")
      expect(described_class).to receive(:new).with(query_config).and_return(results_double)
      expect(results_double).to receive(:as_json).and_return(expected)
      expect(described_class.as_json(query_config)).to eq(expected)
    end
  end

  describe "#as_json" do
    it "builds a respresentation of the campus/term class data and returns it as json" do
      campus_resource = PeoplesoftCourseClassData::XmlParser::Campus.new(campus_id: query_config.campus, abbreviation: query_config.campus)
      term_resource   = PeoplesoftCourseClassData::XmlParser::Term.new(term_id: query_config.term, strm: query_config.term)
      courses_resource = [
                            PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: 1),
                            PeoplesoftCourseClassData::XmlParser::CourseAspect.new(course_id: 2)
                          ]

      expected = "some_json"
      campus_term_course_resource = instance_double("PeoplesoftCourseClassData::XmlParser::CampusTermCourses", to_json: expected)

      coerced_campus = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.campus)
      coerced_term   = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.term)

      expect(PeoplesoftCourseClassData::XmlParser::Campus).to receive(:new).with(coerced_campus, coerced_campus).and_return(campus_resource)
      expect(PeoplesoftCourseClassData::XmlParser::Term).to receive(:new).with(coerced_term, coerced_term).and_return(term_resource)
      expect(PeoplesoftCourseClassData::BuildSources).to receive(:run).with(query_config, subject).and_return(courses_resource)
      expect(PeoplesoftCourseClassData::XmlParser::CampusTermCourses).to receive(:new).with(campus_resource, term_resource, courses_resource).and_return(campus_term_course_resource)

      expect(subject.as_json).to eq(expected)
    end
  end

  describe "run_step" do
    it "runs the provided step, providing the results and itself" do
      next_step = class_double("PeoplesoftCourseClassData::BuildSources")
      results = Object.new
      expect(next_step).to receive(:run).with(results, subject)
      subject.run_step(next_step, results)
    end
  end

end
