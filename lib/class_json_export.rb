require_relative '../config/credentials'
require_relative '../config/query_parameters'
require_relative '../config/file_root'

module PeoplesoftCourseClassData
  class ClassJsonExport
    def initialize(env, path = File.join(::PeoplesoftCourseClassData::Config::FILE_ROOT, 'tmp'), queries = ::PeoplesoftCourseClassData::Config::QUERY_PARAMETERS)
      self.env      = env
      self.path     = path
      self.queries  = queries
    end

    def run
      queries.each do |query|
        config = QueryConfig.new(env, query)
        results = QueryResults.as_json(config)
        p = FileNames.new(config, path).json_with_path
        File.open(p, 'w') do |f|
          f.write(results)
        end
      end
    end

    private
    attr_accessor :env, :queries, :path
  end
end
