require_relative '../../../lib/qas/soap_request_builder'

CONFIG = {
  dev: {
    endpoint: "https://dev.qas.oit.umn.edu/query",
    username: "dev_username",
    password: "dev_password"
  },
  tst: {
    endpoint: "https://tst.qas.oit.umn.edu/query",
    username: "tst_username",
    password: "tst_password"
  },
  prd: {
    endpoint: "https://prd.qas.oit.umn.edu/query",
    username: "prd_username",
    password: "prd_password"
  }
}

describe PeoplesoftCourseClassData::Qas::SoapRequestBuilder do
  let(:env) { CONFIG.keys.sample }
  subject   { PeoplesoftCourseClassData::Qas::SoapRequestBuilder.new(env) }

  describe "#build" do
    it "returns a SoapRequest" do
      expect(subject.build).to be_instance_of(PeoplesoftCourseClassData::Qas::SoapRequest)
    end

    it "sets the SoapRequest endpoint from the config" do
      expect(PeoplesoftCourseClassData::Qas::SoapRequest).to receive(:new).with(CONFIG[env][:endpoint], any_args)
      subject.build
    end

    it "builds a credentials object for the SoapRequest" do
      credentials_double = instance_double("PeoplesoftCourseClassData::Qas::Credentials")
      expect(PeoplesoftCourseClassData::Qas::Credentials).to receive(:new).with(CONFIG[env][:username], CONFIG[env][:password]).and_return(credentials_double)
      expect(PeoplesoftCourseClassData::Qas::SoapRequest).to receive(:new).with(anything, credentials_double)
      subject.build
    end
  end
end