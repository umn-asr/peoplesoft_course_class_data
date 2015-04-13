module PeoplesoftCourseClassData
  class FileNames

    attr_reader :env, :path

    def self.from_file_name(name)
      path, file_name = File.split(name)
      parsed_name = file_name.gsub(/\..+\Z/,'').split('__')
      query = {
                institution: parsed_name[2],
                campus: parsed_name[3],
                term: parsed_name[4]
              }
      new(parsed_name[1], query, path)
    end

    def initialize(env, query, path='.')
      self.env = env
      self.query = query
      self.path = path
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

    def institution
      query[:institution]
    end

    def campus
      query[:campus]
    end

    def term
      query[:term]
    end

    private
    attr_writer   :env, :path
    attr_accessor :query

    def base_name
      "classes_for__#{env}__#{institution}__#{campus}__#{term}"
    end
  end
end