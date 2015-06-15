module PeoplesoftCourseClassData
  class SortData
    def self.run(parsed_data, orchestrator)
      results = Grouping.group(parsed_data).by(:course_id)
      orchestrator.run_step(MergeData, results)
    end
  end
end
