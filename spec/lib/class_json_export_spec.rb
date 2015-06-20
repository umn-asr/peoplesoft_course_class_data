require_relative '../../lib/class_json_export'
require 'ostruct'

RSpec.describe PeoplesoftCourseClassData::ClassJsonExport do
  let(:env)             { :tst }
  let(:parameters_set)  { PeoplesoftCourseClassData::Config::QUERY_PARAMETERS }
  let(:parameters)      { parameters_set.sample }
  let(:path)            { File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/tmp') }
  let(:config_double)   { instance_double(
                                            "PeoplesoftCourseClassData::QueryConfig",
                                            env: env,
                                            institution: parameters[:institution],
                                            campus: parameters[:campus],
                                            term: parameters[:term]
                                          )
                        }
  subject               { described_class.new(env, path, [parameters]) }


  describe "#run" do
    it "builds a QueryConfig" do
      expect(PeoplesoftCourseClassData::QueryConfig).to receive(:new).with(env, parameters).and_return(config_double)
      expect(PeoplesoftCourseClassData::QueryResults).to receive(:as_json)
      subject.run
    end

    it "gets results from QueryResults" do
      allow(PeoplesoftCourseClassData::QueryConfig).to receive(:new).with(env, parameters).and_return(config_double)
      expect(PeoplesoftCourseClassData::QueryResults).to receive(:as_json).with(config_double)
      subject.run
    end

    it "Saves the results to a file, using config and path" do
      names_double = instance_double("PeoplesoftCourseClassData::FileNames")
      allow(names_double).to receive(:json_with_path).and_return("#{path}/test.json")

      results_double = "results"
      allow(PeoplesoftCourseClassData::QueryConfig).to receive(:new).with(env, parameters).and_return(config_double)
      allow(PeoplesoftCourseClassData::QueryResults).to receive(:as_json).with(config_double).and_return(results_double)
      expect(PeoplesoftCourseClassData::FileNames).to receive(:new).with(config_double, path).and_return(names_double)
      subject.run

      expect(File.read("#{path}/test.json")).to eq(results_double)
      `rm -f #{path}/test.json`
    end
  end

end
