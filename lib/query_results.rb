module PeoplesoftCourseClassData
  class QueryResults
    def initialize(query_config)
      self.query_config = query_config
    end

    def to_json
      PeoplesoftCourseClassData::XmlParser::CampusTermCourses.new(campus, term, courses).to_json
    end

    private
    attr_accessor :query_config

    def campus
      campus_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.campus)
      PeoplesoftCourseClassData::XmlParser::Campus.new(campus_value, campus_value)
    end

    def term
      term_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.term)
      PeoplesoftCourseClassData::XmlParser::Term.new(term_value, term_value)
    end

    def courses
      BuildSources.run(query_config, self)
    end
  end

end