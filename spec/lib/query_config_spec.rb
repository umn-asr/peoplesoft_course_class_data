require_relative "../../lib/query_config"

RSpec.describe PeoplesoftCourseClassData::QueryConfig do
  let(:env) { :prd }
  let(:query) { {institution: "UMNTC", campus: "UMNTC", term: "1149"} }
  subject { described_class.new(env, query) }

  describe "env" do
    it "sets the environment in initialize" do
      expect(subject.env).to eq(env)
    end
  end

  describe "institution" do
    it "returns the institution value of the query" do
      expect(subject.institution).to eq(query[:institution])
    end
  end

  describe "campus" do
    it "returns the campus value of the query" do
      expect(subject.campus).to eq(query[:campus])
    end
  end

  describe "term" do
    it "returns the term value of the query" do
      expect(subject.term).to eq(query[:term])
    end
  end

  describe "services" do
    it "returns Services.all" do
      expected = [rand]
      allow(PeoplesoftCourseClassData::Services).to receive(:all).and_return(expected)
      expect(subject.services).to eq(expected)
    end
  end
end
