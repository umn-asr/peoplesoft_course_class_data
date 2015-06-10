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
      service_instance = service.new(soap_request)
      file_path = PeoplesoftCourseClassData::FileNames.new(
        query_config,
        PeoplesoftCourseClassData::Config::TMP_PATH,
        service_name.downcase
      ).xml_with_path

      File.open(file_path, 'w+') do |f|
        f.write("<#{base_tag_name}>")
        service_instance.query(query_config.institution, query_config.campus, query_config.term) do |response|
          f.write(response)
        end
        f.write("</#{base_tag_name}>")
      end

      File.read(file_path)
    end

    def campus
      query_config.campus
    end

    def term
      query_config.term
    end

    def service_name
      service.to_s.demodulize.gsub(/Service\Z/, '')
    end

    private
    attr_accessor :service, :query_config

    def soap_request
     @soap_request ||= PeoplesoftCourseClassData::Qas::SoapRequestBuilder.build(query_config.env)
    end

    def base_tag_name
      "#{service_name.downcase}_service_data"
    end
  end
end
