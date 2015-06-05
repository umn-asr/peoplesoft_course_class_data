require_relative '../../lib/query_results'

RSpec.describe PeoplesoftCourseClassData::QueryResults do
  let(:query_config) { instance_double("PeoplesoftCourseClassData::QueryConfig", campus: 'UMNTC', term: '1149', env: :tst) }
  subject { described_class.new(query_config) }

  describe "#to_json" do
    it "builds a respresentation of the campus/term class data and returns it as json" do
      campus_resource = PeoplesoftCourseClassData::XmlParser::Campus.new(query_config.campus, query_config.campus)
      term_resource   = PeoplesoftCourseClassData::XmlParser::Term.new(query_config.term, query_config.term)
      courses_resource = [
                            PeoplesoftCourseClassData::XmlParser::CourseAspect.new(1),
                            PeoplesoftCourseClassData::XmlParser::CourseAspect.new(2)
                          ]

      expected = "some_json"
      campus_term_course_resource = instance_double("PeoplesoftCourseClassData::XmlParser::CampusTermCourses", to_json: expected)

      coerced_campus = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.campus)
      coerced_term   = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.term)

      expect(PeoplesoftCourseClassData::XmlParser::Campus).to receive(:new).with(coerced_campus, coerced_campus).and_return(campus_resource)
      expect(PeoplesoftCourseClassData::XmlParser::Term).to receive(:new).with(coerced_term, coerced_term).and_return(term_resource)
      expect(PeoplesoftCourseClassData::BuildSources).to receive(:run).with(query_config, subject).and_return(courses_resource)
      expect(PeoplesoftCourseClassData::XmlParser::CampusTermCourses).to receive(:new).with(campus_resource, term_resource, courses_resource).and_return(campus_term_course_resource)

      expect(subject.to_json).to eq(expected)
    end
  end
end