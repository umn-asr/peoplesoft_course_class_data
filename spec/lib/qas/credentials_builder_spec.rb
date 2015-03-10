require_relative '../../../lib/qas/credentials_builder'

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

describe PeoplesoftCourseClassData::Qas::CredentialsBuilder do
  let(:env)   { CONFIG.keys.sample }
  subject     { PeoplesoftCourseClassData::Qas::CredentialsBuilder.new(env) }
  describe "#build" do
    it "returns something that responds to username and password" do
      built = subject.build
      expect(built).to respond_to(:username)
      expect(built).to respond_to(:password)
    end
    it "sets the username using the env" do
      built = subject.build
      expect(built.username).to eq(CONFIG[env][:username])
    end
    it "sets the password using the env" do
      built = subject.build
      expect(built.password).to eq(CONFIG[env][:password])
    end
  end

  describe ".build" do
    it "intanitates a new builder wit the env and calls build on it" do
      credentials_builder_double = instance_double("PeoplesoftCourseClassData::Qas::CredentialsBuilder")
      expect(PeoplesoftCourseClassData::Qas::CredentialsBuilder).to receive(:new).with(env).and_return(credentials_builder_double)
      expect(credentials_builder_double).to receive(:build).and_return(Object.new)

      PeoplesoftCourseClassData::Qas::CredentialsBuilder.build(env)
    end
  end
end