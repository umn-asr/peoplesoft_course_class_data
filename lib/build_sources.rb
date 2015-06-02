require_relative 'workflow'

module PeoplesoftCourseClassData
  class BuildSources
    def self.run(parameters, env, orchestrator)
      results = Services.all.map  { |service| DataSource.build(service, parameters, env) }
      orchestrator.run_step(ParseData, results)
    end
  end
end
