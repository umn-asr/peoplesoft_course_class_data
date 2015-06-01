require_relative 'file_name_config'

module PeoplesoftCourseClassData
  class FileNames

    attr_reader :env, :path, :institution, :campus, :term, :service

    def self.from_file_name(name)
      path, file_name = File.split(name)
      parsed_name = file_name.gsub(/\..+\Z/,'').split('__')
      query = {
                institution: parsed_name[2],
                campus: parsed_name[3],
                term: parsed_name[4]
              }


      config = PeoplesoftCourseClassData::FileNameConfig.new(parsed_name[1], query, "", path)
      new(config)
    end

    def initialize(config)
      self.env         = config.env
      self.institution = config.institution
      self.campus      = config.campus
      self.term        = config.term
      self.service     = config.service
      self.path        = config.path
    end

    def xml
      "#{base_name}.xml"
    end

    def xml_with_path
      File.join(path, xml)
    end

    def json
      "#{base_name}.json"
    end

    def json_with_path
      File.join(path, json)
    end

    private
    attr_writer   :env, :path, :institution, :campus, :term, :service

    def base_name
      "#{service}_for__#{env}__#{institution}__#{campus}__#{term}"
    end
  end
end
