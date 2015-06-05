module PeoplesoftCourseClassData
  class DataSource
    def self.build(service, query_config)
      new(service, query_config)
    end

    def initialize(service, query_config)
      self.service      = service
      self.query_config = query_config
    end

    def data

    end

    def service_name
      service.to_s.demodulize.gsub(/Service\Z/, '')
    end

    private
    attr_accessor :service, :query_config
  end
end
