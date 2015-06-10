RSpec.describe PeoplesoftCourseClassData::BuildSources do
  let(:query_config) { instance_double("PeoplesoftCourseClassData::QueryConfig") }
  let(:orchestrator) { instance_double("PeoplesoftCourseClassData::QueryResults") }

  describe ".run" do
    it "build DataSources, and have orchestrator run the next step" do
      service_double = class_double("PeoplesoftCourseClassData::ClassService")
      source_double = Object.new
      allow(query_config).to receive(:services).and_return([service_double])
      expect(PeoplesoftCourseClassData::DataSource).to receive(:build).with(service_double, query_config).and_return(source_double)

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::ParseData, [source_double])
      PeoplesoftCourseClassData::BuildSources.run(query_config, orchestrator)
    end
  end
end
