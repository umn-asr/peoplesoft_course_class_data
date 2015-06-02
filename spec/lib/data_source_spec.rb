require_relative '../../lib/data_source'

RSpec.describe PeoplesoftCourseClassData::DataSource do
  let(:env)     { :tst }
  let(:query)   { PeoplesoftCourseClassData::Config::QUERY_PARAMETERS.sample }
  let(:service) { Object }

  describe ".build" do
    it "creates a new DataSource" do
      expect(described_class.build(service, query, env)).to be_instance_of(PeoplesoftCourseClassData::DataSource)
    end
  end

  describe "#term" do

  end
end
