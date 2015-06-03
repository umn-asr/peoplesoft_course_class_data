require_relative 'workflow'

module PeoplesoftCourseClassData
  class MergeData
    def self.run(course_aspects, orchestrator)
      course_aspects.flatten.inject(:merge)
    end
  end
end
