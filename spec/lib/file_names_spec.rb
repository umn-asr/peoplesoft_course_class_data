require_relative '../../lib/file_names'

RSpec.describe PeoplesoftCourseClassData::FileNames do
  let(:env)   { :prd }
  let(:query) { {institution: 'UMNTC', campus: 'UMNTC', term: '1149'} }
  let(:path)  { 'path/to/some/directory' }
  subject { described_class.new(env, query, path) }

  describe "#xml" do
    it "returns classes_for__env__institituion__campus__term.xml" do
      expect(subject.xml).to eq("classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.xml")
    end
  end

  describe "#xml_with_path" do
    it "returns classes_for__env__institituion__campus__term.xml" do
      expect(subject.xml_with_path).to eq("#{path}/classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.xml")
    end

    it "works when the path has a trailing /" do
      trailing_slash_path = 'path/with/trailing/slash/'
      subject = described_class.new(env, query, trailing_slash_path)
      expect(subject.xml_with_path).to eq("#{trailing_slash_path}classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.xml")
    end
  end

  describe "#json" do
    it "returns classes_for__env__institituion__campus__term.json" do
      expect(subject.json).to eq("classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.json")
    end
  end

  describe "#json_path" do
    it "returns classes_for__env__institituion__campus__term.json" do
      expect(subject.json_with_path).to eq("#{path}/classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.json")
    end

    it "works when the path has a trailing /" do
      trailing_slash_path = 'path/with/trailing/slash/'
      subject = described_class.new(env, query, trailing_slash_path)
      expect(subject.json_with_path).to eq("#{trailing_slash_path}classes_for__#{env}__#{query[:institution]}__#{query[:campus]}__#{query[:term]}.json")
    end
  end

  describe ".from_file_name" do
    let(:file_name) { '/path/to/classes_for__dev__UMNTC__UMNRO__1149.json' }
    subject { described_class.from_file_name(file_name) }

    it "returns 'dev' for env" do
      expect(subject.env).to eq('dev')
    end

    it "returns 'UMNTC' for institution" do
      expect(subject.institution).to eq('UMNTC')
    end

    it "returns 'UMNRO' for campus" do
      expect(subject.campus).to eq('UMNRO')
    end

    it "returns '1149' for term" do
      expect(subject.term).to eq('1149')
    end

    it "returns the path to the file for path_name" do
      expect(subject.path).to eq('/path/to')
    end

    context "when no path is supplied" do
      let(:file_name) { 'classes_for__dev__UMNTC__UMNRO__1149.json' }
      subject { described_class.from_file_name(file_name) }


      it "returns '.' for path" do
        expect(subject.path).to eq('.')
      end

      it "returns 'dev' for env" do
        expect(subject.env).to eq('dev')
      end

      it "returns 'UMNTC' for institution" do
        expect(subject.institution).to eq('UMNTC')
      end

      it "returns 'UMNRO' for campus" do
        expect(subject.campus).to eq('UMNRO')
      end

      it "returns '1149' for term" do
        expect(subject.term).to eq('1149')
      end

    end
  end

end