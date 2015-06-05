require_relative '../../lib/file_names'

RSpec.describe PeoplesoftCourseClassData::FileNames, :focus do
  let(:query_config)  { instance_double("PeoplesoftCourseClassData::QueryConfig", env: :tst, institution: 'UMNTC', campus: 'UMNTC', term: '1149') }
  let(:path)          { 'path/to/some/directory' }
  let(:prefix)        { 'prefix' }

  subject { described_class.new(query_config, path, prefix) }

  describe "#xml" do
    it "returns prefix__env__institituion__campus__term.xml" do
      expect(subject.xml).to eq("#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.xml")
    end
  end

  describe "#xml_with_path" do
    it "returns service_for__env__institituion__campus__term.xml" do
      expect(subject.xml_with_path).to eq("#{path}/#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.xml")
    end

    it "works when the path has a trailing /" do
      trailing_slash_path = 'path/with/trailing/slash/'
      subject = described_class.new(query_config, trailing_slash_path, prefix)
      expect(subject.xml_with_path).to eq("#{trailing_slash_path}#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.xml")
    end
  end

  describe "#json" do
    it "returns service_for__env__institituion__campus__term.json" do
      expect(subject.json).to eq("#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.json")
    end
  end

  describe "#json_path" do
    it "returns service_for__env__institituion__campus__term.json" do
      expect(subject.json_with_path).to eq("#{path}/#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.json")
    end

    it "works when the path has a trailing /" do
      trailing_slash_path = 'path/with/trailing/slash/'
      subject = described_class.new(query_config, trailing_slash_path, prefix)
      expect(subject.json_with_path).to eq("#{trailing_slash_path}#{prefix}_for__#{query_config.env}__#{query_config.institution}__#{query_config.campus}__#{query_config.term}.json")
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
