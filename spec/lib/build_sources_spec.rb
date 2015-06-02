require_relative '../../lib/build_sources'

RSpec.describe PeoplesoftCourseClassData::BuildSources do
  let(:parameters)   { PeoplesoftCourseClassData::Config::QUERY_PARAMETERS.sample }
  let(:env)     { :tst }
  let(:orchestrator) { instance_double("PeoplesoftCourseClassData::ClassJsonExport") }

  describe ".run" do
    it "build DataSources, and have orchestrator run the next step" do
      service_double = class_double("PeoplesoftCourseClassData::ClassService")
      source_double = Object.new
      allow(PeoplesoftCourseClassData::Services).to receive(:all).and_return([service_double])
      expect(PeoplesoftCourseClassData::DataSource).to receive(:build).with(service_double, parameters, env).and_return(source_double)

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::GetData, [source_double])
      PeoplesoftCourseClassData::BuildSources.run(parameters, env, orchestrator)
    end
  end
end

