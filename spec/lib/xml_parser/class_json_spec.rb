require_relative '../../../config/file_root'

require_relative '../../../lib/xml_parser/class_json'

RSpec.describe PeoplesoftCourseClassData::XmlParser::ClassJson do
  let(:fixture_directory) { "#{PeoplesoftCourseClassData::Config::FILE_ROOT}/spec/fixtures" }

  let(:service)       { PeoplesoftCourseClassData::ClassService }
  let(:query_config)  { PeoplesoftCourseClassData::QueryConfig.new(:tst, {institution: 'UMNTC', campus: 'UMNTC', term: '1149'}) }
  let(:data_source)   { PeoplesoftCourseClassData::DataSource.build(service, query_config) }

  before do
  end

  after do
  end

  describe "parse" do
    it "returns the expected json" do
      data_source_data = "<class_service_data>"
      data_source_data += File.read("#{fixture_directory}/reference.xml")
      data_source_data += "</class_service_data>"

      allow(data_source).to receive(:data).and_return(data_source_data)
      allow(data_source).to receive(:campus).and_return("UMNTC")
      allow(data_source).to receive(:term).and_return("1159")

      results = described_class.parse(data_source)
      expected_json = "{\"campus\":{\"type\":\"campus\",\"campus_id\":\"UMNTC\",\"abbreviation\":\"UMNTC\"},\"term\":{\"type\":\"term\",\"term_id\":\"1159\",\"strm\":\"1159\"},\"courses\":[{\"type\":\"course\",\"course_id\":\"795342\",\"catalog_number\":\"3120\",\"description\":\"Political, cultural, historical linkages between Africans, African-Americans, African-Caribbean. Black socio-political movements/radical intellectual trends in late 19th/20th centuries. Colonialism/racism. Protest organizations, radical movements in United States/Europe.\",\"title\":\"Soc Mvts in African Diaspora\",\"subject\":{\"type\":\"subject\",\"subject_id\":\"AFRO\",\"description\":\"African Amer & African Studies\"},\"equivalency\":{\"type\":\"equivalency\",\"equivalency_id\":\"00788\"},\"course_attributes\":[{\"type\":\"attribute\",\"attribute_id\":\"GP\",\"family\":\"CLE\"}],\"sections\":[{\"type\":\"section\",\"class_number\":\"26191\",\"number\":\"001\",\"component\":\"LEC\",\"location\":\"TCWESTBANK\",\"credits_minimum\":\"3\",\"credits_maximum\":\"3\",\"notes\":\"\",\"instruction_mode\":{\"type\":\"instruction_mode\",\"instruction_mode_id\":\"P\",\"description\":\"In Person Term Based\"},\"grading_basis\":{\"type\":\"grading_basis\",\"grading_basis_id\":\"AFV\",\"description\":\"A-F or Audit\"},\"instructors\":[{\"type\":\"instructor\",\"name\":\"Yuichiro Onishi\",\"email\":\"remove@umn.edu\",\"role\":\"PI\"}],\"meeting_patterns\":[{\"type\":\"meeting_pattern\",\"start_time\":\"13:00\",\"end_time\":\"14:15\",\"start_date\":\"2014-09-02\",\"end_date\":\"2014-12-10\",\"location\":{\"type\":\"location\",\"location_id\":\"BLEGH00155\",\"description\":\"Blegen Hall 155\"},\"days\":[{\"type\":\"day\",\"name\":\"tuesday\",\"abbreviation\":\"t\"},{\"type\":\"day\",\"name\":\"thursday\",\"abbreviation\":\"th\"}]}],\"combined_sections\":[{\"type\":\"combined_section\",\"catalog_number\":\"5120\",\"subject_id\":\"AFRO\",\"section_number\":\"001\"}]}]},{\"type\":\"course\",\"course_id\":\"002066\",\"catalog_number\":\"1101W\",\"description\":\"Fundamental principles of physics in the context of everyday world. Use of kinematics/dynamics principles and quantitative/qualitative problem solving techniques to understand natural phenomena. Lecture, recitation, lab.\",\"title\":\"Intro College Phys I\",\"subject\":{\"type\":\"subject\",\"subject_id\":\"PHYS\",\"description\":\"Physics\"},\"course_attributes\":[{\"type\":\"attribute\",\"attribute_id\":\"PHYS\",\"family\":\"CLE\"}],\"sections\":[{\"type\":\"section\",\"class_number\":\"10793\",\"number\":\"108\",\"component\":\"DIS\",\"location\":\"TCEASTBANK\",\"credits_minimum\":\"4\",\"credits_maximum\":\"4\",\"notes\":\"\",\"instruction_mode\":{\"type\":\"instruction_mode\",\"instruction_mode_id\":\"P\",\"description\":\"In Person Term Based\"},\"grading_basis\":{\"type\":\"grading_basis\",\"grading_basis_id\":\"OPT\",\"description\":\"Student Option\"},\"instructors\":[{\"type\":\"instructor\",\"name\":\"Jennifer Kroschel\",\"email\":\"remove@umn.edu\",\"role\":\"PRXY\"}],\"meeting_patterns\":[{\"type\":\"meeting_pattern\",\"start_time\":\"13:25\",\"end_time\":\"14:15\",\"start_date\":\"2014-09-02\",\"end_date\":\"2014-12-10\",\"location\":{\"type\":\"location\",\"location_id\":\"BUH0000120\",\"description\":\"Burton Hall 120\"},\"days\":[{\"type\":\"day\",\"name\":\"thursday\",\"abbreviation\":\"th\"}]}],\"combined_sections\":[]}]}]}"
      expect(results).to eq(expected_json)
    end
  end
end
