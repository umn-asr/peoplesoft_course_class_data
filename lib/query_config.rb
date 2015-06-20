module PeoplesoftCourseClassData
  class QueryConfig
    attr_reader :env

    def initialize(env, query)
      self.env = env
      self.query = query
    end

    def services
      Services.all
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

    attr_writer :env
    attr_accessor :query
  end
end
