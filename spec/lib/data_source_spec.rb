RSpec.describe PeoplesoftCourseClassData::DataSource do
  let(:query_config)   do
                          instance_double(
                                          "PeoplesoftCourseClassData::QueryConfig",
                                          institution: 'UMNTC',
                                          campus: 'UMNTC',
                                          term: '1149',
                                          env: :tst
                                        )
                      end
  let(:service) { Object }

  describe ".build" do
    it "creates a new DataSource" do
      expect(described_class.build(service, query_config)).to be_instance_of(PeoplesoftCourseClassData::DataSource)
    end
  end

  describe "#data" do
    let(:soap_request_instance) { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }
    let(:service)               { [PeoplesoftCourseClassData::ClassService, PeoplesoftCourseClassData::CourseService].sample }
    let(:service_instance)      { instance_double(service.name) }

    subject { described_class.new(service, query_config) }

    before do
      # stub out collaborators so we can make assertions about each step in seperate tests
      allow(PeoplesoftCourseClassData::Qas::SoapRequestBuilder).to receive(:build).and_return(soap_request_instance)
      allow(service).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:query).and_yield('')
    end

    it "configures a soap request for the supplied environment" do
      expect(PeoplesoftCourseClassData::Qas::SoapRequestBuilder).to receive(:build).with(query_config.env).and_return(soap_request_instance)
      subject.data
    end

    it "builds an instane of the service using the soap request" do
      expect(service).to receive(:new).with(soap_request_instance).and_return(service_instance)
      subject.data
    end

    describe "response" do
      let(:taggified_service_name) { service.name.demodulize.gsub(/Service\Z/, '').downcase }

      it "returns the data from the service, wrapped in a tag" do
        query_data              = "<xml>data</xml>"
        expected                = "<#{taggified_service_name}_service_data>#{query_data}</#{taggified_service_name}_service_data>"
        allow(service_instance).to receive(:query).with(query_config.institution, query_config.campus, query_config.term).and_yield(query_data)
        expect(subject.data).to eq(expected)
      end

      it "wraps all responses from the query in a single tag" do
        response_1 = "<xml>response_1</xml>"
        response_2 = "<xml>response_2</xml>"
        expected   = "<#{taggified_service_name}_service_data>#{response_1}#{response_2}</#{taggified_service_name}_service_data>"
        allow(service_instance).to receive(:query).with(query_config.institution, query_config.campus, query_config.term).and_yield(response_1).and_yield(response_2)
        expect(subject.data).to eq(expected)
      end
    end
  end

  describe "#service_name" do
    it "returns the service from initalization, with 'PeoplesoftCourseClassData' and 'Service' removed" do
      data_source = described_class.build(PeoplesoftCourseClassData::ClassService, query_config)
      expect(data_source.service_name).to eq('Class')
    end
  end
end
