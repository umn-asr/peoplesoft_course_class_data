require_relative '../../lib/data_source'

RSpec.describe PeoplesoftCourseClassData::DataSource do
  let(:query_config)   { instance_double("PeoplesoftCourseClassData::QueryConfig") }
  let(:service) { Object }

  describe ".build" do
    it "creates a new DataSource" do
      expect(described_class.build(service, query_config)).to be_instance_of(PeoplesoftCourseClassData::DataSource)
    end
  end

  describe "#service_name" do
    it "returns the service from initalization, with 'PeoplesoftCourseClassData' and 'Service' removed" do
      data_source = described_class.build(PeoplesoftCourseClassData::ClassService, query_config)
      expect(data_source.service_name).to eq('Class')
    end
  end
end
