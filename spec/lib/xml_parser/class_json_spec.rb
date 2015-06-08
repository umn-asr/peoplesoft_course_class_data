require_relative '../../../config/file_root'

require_relative '../../../lib/xml_parser/class_json'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ClassJson do

  let(:name_config)     { PeoplesoftCourseClassData::FileNameConfig.new(:tst, {institution: 'UMNTC', campus: 'UMNTC', term: '1149'}, "classes") }
  let(:file_name)         { PeoplesoftCourseClassData::FileNames.new(name_config) }
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }
  let(:working_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/tmp" }


  before do
    `cp #{fixture_directory}/reference.xml #{working_directory}/#{file_name.xml}`
  end

  after do
    `rm #{working_directory}/*`
  end

  subject { described_class.new("#{working_directory}/#{file_name.xml}") }

  describe "to_file" do
    it "creates a .json file with the same name as the xml file in the same directory" do
      subject.to_file

      file_path = "#{working_directory}/#{file_name.json}"
      expect(File.exist?(file_path)).to eq(true)
    end

    it "contains the correct json" do
      expected_file = File.open("#{fixture_directory}/reference.json", 'r')
      expected_json = JSON.parse(expected_file.read, object_class: OpenStruct, array_class: Set)
      expected_file.close

      subject.to_file

      actual_file = File.open("#{working_directory}/#{file_name.json}", 'r')
      actual_json = JSON.parse(actual_file.read, object_class: OpenStruct, array_class: Set)
      actual_file.close

      expect(actual_json).to eq(expected_json)
    end

    context "when the xml has no data for a sub resources" do
      context "example 1 - grading basis" do
        before do
          `cp #{fixture_directory}/no_grading_basis.xml #{working_directory}/#{file_name.xml}`
        end

        it "does not build the grading basis attribute" do
          subject.to_file

          json = JSON.parse(File.read("#{working_directory}/#{file_name.json}"))
          section_keys = json["courses"].flat_map { |course| course["sections"] }.flat_map(&:keys).uniq

          expect(section_keys).not_to be_empty
          expect(section_keys).not_to include("grading_basis")
        end
      end

      context "example 2 - instruction mode" do
        before do
          `cp #{fixture_directory}/no_instruction_mode.xml #{working_directory}/#{file_name.xml}`
        end

        it "does not build the instruction mode attribute" do
          subject.to_file

          json = JSON.parse(File.read("#{working_directory}/#{file_name.json}"))
          section_keys = json["courses"].flat_map { |course| course["sections"] }.flat_map(&:keys).uniq

          expect(section_keys).not_to be_empty
          expect(section_keys).not_to include("instruction_mode")
        end
      end
    end
  end
end
