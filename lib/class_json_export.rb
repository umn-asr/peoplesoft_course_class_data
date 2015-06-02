require_relative '../config/credentials'
require_relative '../config/query_parameters'
require_relative '../config/file_root'

require_relative 'class_service'
require_relative 'course_service'
require_relative 'services'
require_relative 'data_source'
require_relative 'file_names'
require_relative 'build_sources'
require_relative 'get_data'
require_relative 'xml_parser/class_json'

module PeoplesoftCourseClassData
  class ClassJsonExport
    def initialize(env, path = File.join(::PeoplesoftCourseClassData::Config::FILE_ROOT, 'tmp'), queries = ::PeoplesoftCourseClassData::Config::QUERY_PARAMETERS)
      self.env      = env
      self.path     = path
      self.queries  = queries
    end

    def run_step(step, results)
    end

    def run
      queries.each do |query|
        BuildSources.run(query, env, self)

        Services.all.each do |service|
          DataSource.build(service, query, env)
        end
        download_xml(query)
        convert_to_json(query)
      end
    end

    private
    attr_accessor :env, :queries, :path

    def download_xml(query)
      File.open(xml_file(query), 'w+') do |f|
        f.write("<class_service_data>")
        class_service.query(query[:institution], query[:campus], query[:term]) do |response|
          f.write(response)
        end
        f.write("</class_service_data>")
      end

      File.open(xml_file(query, "courses"), 'w+') do |f|
        f.write("<course_service_data>")
        course_service.query(query[:institution], query[:campus], query[:term]) do |response|
          f.write(response)
        end
        f.write("</course_service_data>")
      end
    end

    def convert_to_json(query)
      PeoplesoftCourseClassData::XmlParser::ClassJson.new(xml_file(query)).to_file
    end

    def xml_file(query, service = "classes")
      config = PeoplesoftCourseClassData::FileNameConfig.new(env, query, service, path)
      PeoplesoftCourseClassData::FileNames.new(config).xml_with_path
    end

    def class_service
      @class_service ||= PeoplesoftCourseClassData::ClassService.new(soap_request)
    end

    def course_service
      @course_service ||= PeoplesoftCourseClassData::CourseService.new(soap_request)
    end

    def soap_request
     @soap_request ||= PeoplesoftCourseClassData::Qas::SoapRequestBuilder.build(env)
    end
  end
end
