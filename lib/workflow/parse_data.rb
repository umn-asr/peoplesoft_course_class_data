module PeoplesoftCourseClassData
  class ParseData
    def self.run(sources, orchestrator)
      PeoplesoftCourseClassData::StepProfiler.log("parse results starting.")
      results = sources.flat_map do |source|
                  PeoplesoftCourseClassData::XmlParser::AspectParser.parse(
                    PeoplesoftCourseClassData::XmlParser::NodeSet.build(source.data),
                    "PeoplesoftCourseClassData::XmlParser::#{source.service_name}Rows".safe_constantize,
                    orchestrator.term,
                    orchestrator.campus
                  )
                end
      PeoplesoftCourseClassData::StepProfiler.log("parse results completed. moving to next step")
      orchestrator.run_step(MergeData, results)
    end
  end
end
