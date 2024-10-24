module PeoplesoftCourseClassData
  class ParseData
    def self.run(sources, orchestrator)
      results = sources.map do |source|
        PeoplesoftCourseClassData::XmlParser::AspectParser.parse(
          PeoplesoftCourseClassData::XmlParser::NodeSet.build(source.data),
          "PeoplesoftCourseClassData::XmlParser::#{source.service_name}Rows".safe_constantize
        )
      end
      orchestrator.run_step(SortData, results)
    end
  end
end
