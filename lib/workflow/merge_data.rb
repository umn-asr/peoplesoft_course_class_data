module PeoplesoftCourseClassData
  class MergeData
    def self.run(collections, orchestrator)
      collections.map { |collection| collection.inject(:merge) }
    end
  end
end
