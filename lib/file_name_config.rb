module PeoplesoftCourseClassData
  class FileNameConfig
    attr_reader :env, :service, :path

    def initialize(env, query, service, path = '.')
      self.env = env
      self.query = query
      self.service = service
      self.path = path
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

    attr_writer :env, :service, :path
    attr_accessor :query
  end
end
