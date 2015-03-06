require_relative '../../../lib/qas/qas'
require_relative '../../../lib/qas/query_with_polled_response'

RSpec.describe PeoplesoftCourseClassData::Qas::QueryWithPolledResponse do
  let(:soap_request_double)  { instance_double("PeoplesoftCourseClassData::Qas::SoapRequest") }

  subject { PeoplesoftCourseClassData::Qas::QueryWithPolledResponse.new(soap_request_double) }
  describe "#run" do
    let(:start_sync_poll_query_double) { instance_double("PeoplesoftCourseClassData::Qas::StartSyncPollQuery") }
    let(:get_query_results_double)     { instance_double("PeoplesoftCourseClassData::Qas::GetQueryResults")}
    let(:payload)                      { "<xml>Enterprise</xml>"}
    it "executes a StartSyncPollQuery" do
      expect(PeoplesoftCourseClassData::Qas::StartSyncPollQuery).to receive(:new).with(soap_request_double) { start_sync_poll_query_double }
      expect(start_sync_poll_query_double).to receive(:run).with(payload)

      allow(PeoplesoftCourseClassData::Qas::GetQueryResults).to receive(:new) { get_query_results_double }
      allow(get_query_results_double).to receive(:poll)

      subject.run(payload)
    end
    it "instantiates a GetQueryResults with the StartSyncPollQuery's query_instance and poll" do
      query_id = "fancy_UUID"
      allow(PeoplesoftCourseClassData::Qas::StartSyncPollQuery).to receive(:new) { start_sync_poll_query_double }
      allow(start_sync_poll_query_double).to receive(:run) { query_id }

      expect(PeoplesoftCourseClassData::Qas::GetQueryResults).to receive(:new).with(soap_request_double, query_id) { get_query_results_double }
      expect(get_query_results_double).to receive(:poll)
      subject.run(payload)
    end
  end
end