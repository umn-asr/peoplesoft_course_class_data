require_relative '../../lib/parse_data'

RSpec.describe PeoplesoftCourseClassData::ParseData do
  describe ".run" do
    it "gets the data from the sources, and parses with the appropriate parser" do
      sources = [
                  instance_double("PeoplesoftCourseClassData::DataSource", service_name: 'Class', data: "<xml>Classes</xml>"),
                  instance_double("PeoplesoftCourseClassData::DataSource", service_name: 'Course', data: "<xml>Courses</xml>")
                ]
      orchestrator = instance_double("PeoplesoftCourseClassData::QueryResults")

      results = []


      sources.each do |source|
        allow(source).to receive(:data).and_return("<xml>XML!</xml>")
        expect(PeoplesoftCourseClassData::XmlParser::NodeSet).to receive(:build).with(source.data).and_return(source.data)

        parser = "PeoplesoftCourseClassData::XmlParser::#{source.service_name}Parser".safe_constantize
        source_results = [Object.new]
        expect(parser).to receive(:parse).with(source.data).and_return(source_results)

        results << source_results
      end

      expect(orchestrator).to receive(:run_step).with(PeoplesoftCourseClassData::SortData, results)

      described_class.run(sources, orchestrator)
    end
  end
end
