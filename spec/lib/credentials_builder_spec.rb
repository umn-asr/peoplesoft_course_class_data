require_relative '../../lib/credentials_builder'

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

describe PeoplesoftCourseClassData::CredentialsBuilder do
  let(:env)   { CONFIG.keys.sample }
  subject     { PeoplesoftCourseClassData::CredentialsBuilder.new(env) }
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
end