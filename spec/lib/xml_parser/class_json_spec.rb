require_relative '../../../config/file_root'

require_relative '../../../lib/xml_parser/class_json'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ClassJson do

  let(:file_name)         { PeoplesoftCourseClassData::FileNames.new(:tst, {institution: 'UMNTC', campus: 'UMNTC', term: '1149'}) }
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }
  let(:working_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/tmp" }


  before do
    `cp #{fixture_directory}/reference.xml #{working_directory}/#{file_name.xml}`
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
      expected_json = sorted_class_data!(JSON.parse(expected_file.read))
      expected_file.close

      subject.to_file

      actual_file = File.open("#{working_directory}/#{file_name.json}", 'r')
      actual_json = sorted_class_data!(JSON.parse(actual_file.read))
      actual_file.close

      expect(actual_json).to eq(expected_json)
    end
  end

  def sorted_class_data!(class_data)
    class_data["courses"].sort_by! { |course| course["course_id"] }
    class_data["courses"].each do |course|
      course["cle_attributes"].sort_by! { |cle_attribute| cle_attribute["attribute_id"] }
      course["sections"].sort_by! { |section| section["number"] }
      course["sections"].each do |section|
        section["instructors"].sort_by! { |instructor| instructor["name"] }
        section["meeting_patterns"].sort_by! { |pattern| pattern["start_date"] }
        section["meeting_patterns"].each do |pattern|
          pattern["days"].sort_by! { |day| day["name"] }
        end
        section["combined_sections"].sort_by! { |combined_section| combined_section["catalog_number"]}
      end
    end
  end
end
