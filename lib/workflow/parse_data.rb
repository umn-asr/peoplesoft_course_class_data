module PeoplesoftCourseClassData
  class ParseData
    def self.run(sources, orchestrator)
      results = sources.map do |source|
                  parser = "PeoplesoftCourseClassData::XmlParser::#{source.service_name}Parser".safe_constantize
                  parser.parse(PeoplesoftCourseClassData::XmlParser::NodeSet.build(source.data))
                end
      orchestrator.run_step(SortData, results)
    end
  end
end
