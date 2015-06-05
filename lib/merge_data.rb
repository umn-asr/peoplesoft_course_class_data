require_relative 'workflow'

module PeoplesoftCourseClassData
  class MergeData
    def self.run(collections, orchestrator)
      courses = collections.map { |collection| collection.inject(:merge) }
      orchestrator.run_step(WriteData, courses)
    end
  end
end
