module PeoplesoftCourseClassData
  class QueryResults
    def self.as_json(config)
      new(config).as_json
    end

    def initialize(query_config)
      self.query_config = query_config
    end

    def run_step(step, results)
      step.run(results, self)
    end

    def as_json
      PeoplesoftCourseClassData::XmlParser::CampusTermCourses.new(campus: campus, term: term, courses: courses).to_json
    end

    private

    attr_accessor :query_config

    def campus
      campus_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.campus)
      PeoplesoftCourseClassData::XmlParser::Campus.new(campus_id: campus_value, abbreviation: campus_value)
    end

    def term
      term_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(query_config.term.to_s)
      PeoplesoftCourseClassData::XmlParser::Term.new(term_id: term_value, strm: term_value)
    end

    def courses
      BuildSources.run(query_config, self)
    end
  end
end
