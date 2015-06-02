module PeoplesoftCourseClassData
  class DataSource
    def self.build(service, query_parameters, env)
      new(service, query_parameters, env)
    end

    def initialize(service, query_parameters, env)
      self.service          = service
      self.query_parameters = query_parameters
      self.env              = env
    end

    def data

    end

    def service_name
      service.to_s.demodulize.gsub(/Service\Z/, '')
    end

    private
    attr_accessor :service, :query_parameters, :env
  end
end