require_relative '../../lib/class_json_export'
require 'ostruct'

RSpec.describe PeoplesoftCourseClassData::ClassJsonExport do
  let(:soap_request_double)   { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }
  let(:class_service_double)  { instance_double("PeoplesoftCourseClassData::ClassService") }
  let(:course_service_double) { instance_double("PeoplesoftCourseClassData::CourseService") }
  let(:class_json_double)     { instance_double("PeoplesoftCourseClassData::XmlParser::ClassJson") }

  let(:env)             { :tst }
  let(:parameters_set)  { PeoplesoftCourseClassData::Config::QUERY_PARAMETERS }
  let(:parameters)      { parameters_set.sample }
  let(:path)            { File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/tmp') }

  let(:name_config)     { PeoplesoftCourseClassData::FileNameConfig.new(env, parameters, "classes", path) }
  subject               { described_class.new(env, path, [parameters]) }


  describe "#run" do
    let(:xml_response)  { "<xml>Enterprise!</xml>" }
    let(:response_file) { PeoplesoftCourseClassData::FileNames.new(name_config).xml_with_path }
    before do
      allow(PeoplesoftCourseClassData::Qas::SoapRequestBuilder).to receive(:build).with(env).and_return(soap_request_double)
      allow(PeoplesoftCourseClassData::ClassService).to receive(:new).with(soap_request_double).and_return(class_service_double)
      allow(PeoplesoftCourseClassData::CourseService).to receive(:new).with(soap_request_double).and_return(course_service_double)

      allow(PeoplesoftCourseClassData::BuildSources).to receive(:run)

      allow(class_service_double).to receive(:query).and_yield(xml_response)
      allow(course_service_double).to receive(:query).and_yield(xml_response)
      allow(class_json_double).to receive(:to_file)
    end

    after do
      `rm #{path}/*_for__tst*`
    end

    it "configures a soap request for the supplied environment" do
      expect(PeoplesoftCourseClassData::Qas::SoapRequestBuilder).to receive(:build).with(env).and_return(soap_request_double)

      subject.run
    end

    it "builds a class_service" do
      expect(PeoplesoftCourseClassData::ClassService).to receive(:new).with(soap_request_double).and_return(class_service_double)

      subject.run
    end

    it "builds a course_service" do
      expect(PeoplesoftCourseClassData::CourseService).to receive(:new).with(soap_request_double).and_return(course_service_double)

      subject.run
    end

    it "creates two xml files for a single set of parameters" do
      subject.run
      xml_file_count = Dir.glob("#{path}/*xml").count
      expect(xml_file_count).to eq(2)
    end

    it "calls query on the class service for each set of parameters" do
      multiple_queries = parameters_set.sample(rand(1..(parameters_set.length-1)))
      subject = described_class.new(env, path, multiple_queries)

      multiple_queries.each do |query_parameters|
        expect(class_service_double).to receive(:query).with(query_parameters[:institution], query_parameters[:campus], query_parameters[:term])
      end

      subject.run
    end

    it "calls query on the course service for each set of parameters" do
      multiple_queries = parameters_set.sample(rand(1..(parameters_set.length-1)))
      subject = described_class.new(env, path, multiple_queries)

      multiple_queries.each do |query_parameters|
        expect(course_service_double).to receive(:query).with(query_parameters[:institution], query_parameters[:campus], query_parameters[:term])
      end

      subject.run
    end

    it "writes the results to a file located at path" do
      subject.run

      expect(File.open(response_file).read).to include(xml_response)
    end

    it "builds an instance of ClassJson with the xml file and calls .to_file on it" do
      expect(PeoplesoftCourseClassData::XmlParser::ClassJson).to receive(:new).with(response_file).and_return(class_json_double)
      expect(class_json_double).to receive(:to_file)

      subject.run
    end

    it "builds a QueryConfig" do
      expect(PeoplesoftCourseClassData::QueryConfig).to receive(:new).with(env, parameters)
      expect(PeoplesoftCourseClassData::QueryResults).to receive(:new)
      subject.run
    end

    it "gets results from QueryResults" do
      config_double = instance_double("PeoplesoftCourseClassData::QueryConfig")
      allow(PeoplesoftCourseClassData::QueryConfig).to receive(:new).with(env, parameters).and_return(config_double)
      expect(PeoplesoftCourseClassData::QueryResults).to receive(:new).with(config_double)
      subject.run
    end
  end

end
