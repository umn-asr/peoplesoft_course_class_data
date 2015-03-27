module PeoplesoftCourseClassData
  class FileNames

    attr_reader :env

    def self.from_file_name(name)
      parsed_name = name.gsub(/\..+\Z/,'').split('__')
      query = {
                institution: parsed_name[2],
                campus: parsed_name[3],
                term: parsed_name[4]
              }
      new(parsed_name[1], query)
    end

    def initialize(env, query)
      self.env = env
      self.query = query
    end

    def xml
      "#{base_name}.xml"
    end

    def json
      "#{base_name}.json"
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
    attr_writer   :env
    attr_accessor :query

    def base_name
      "classes_for__#{env}__#{institution}__#{campus}__#{term}"
    end
  end
end