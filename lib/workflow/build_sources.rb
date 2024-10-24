module PeoplesoftCourseClassData
  class BuildSources
    def self.run(query_config, orchestrator)
      results = query_config.services.map { |service| DataSource.build(service, query_config) }
      orchestrator.run_step(ParseData, results)
    end
  end
end
