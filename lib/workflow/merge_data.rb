module PeoplesoftCourseClassData
  class MergeData
    def self.run(collections, orchestrator)
      PeoplesoftCourseClassData::StepProfiler.log("merge data starting.")
      merged = collections.inject(:merge)
      PeoplesoftCourseClassData::StepProfiler.log("merge data completed.")
      merged
    end
  end
end
