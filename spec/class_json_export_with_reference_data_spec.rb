require_relative '../lib/class_json_export'

RSpec.describe 'XmlToJsonIntegration' do
  describe "ClassJsonExport#run with actual xml data" do
    it "matches the reference json" do
      env        = :prd
      parameters = {
                      institution: "UMNTC",
                      campus: "UMNTC",
                      term: "1149"
                    }
      path       = File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/tmp')


      class_xml_file = File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/fixtures/reference_classes.xml')
      class_service_double = instance_double("PeoplesoftCourseClassData::ClassService")
      allow(class_service_double).to receive(:query).and_yield(File.read(class_xml_file))

      course_xml_file = File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/fixtures/reference_courses.xml')
      course_service_double = instance_double("PeoplesoftCourseClassData::CourseService")
      allow(course_service_double).to receive(:query).and_yield(File.read(course_xml_file  ))


      allow(PeoplesoftCourseClassData::ClassService).to receive(:new).and_return(class_service_double)
      allow(PeoplesoftCourseClassData::CourseService).to receive(:new).and_return(course_service_double)

      reference_json_file = File.join(PeoplesoftCourseClassData::Config::FILE_ROOT, 'spec/fixtures/reference_combined.json')
      actual_json_file = PeoplesoftCourseClassData::FileNames.new(PeoplesoftCourseClassData::QueryConfig.new(env, parameters), path).json_with_path

      PeoplesoftCourseClassData::ClassJsonExport.new(env, path, [parameters]).run

      reference_json = JSON.parse(File.read(reference_json_file), object_class: OpenStruct, array_class: Set)
      actual_json = JSON.parse(File.read(actual_json_file), object_class: OpenStruct, array_class: Set)
      expect(actual_json).to eq(reference_json)

      `rm -f #{actual_json_file}`
    end
  end
end