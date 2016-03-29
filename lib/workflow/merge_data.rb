module PeoplesoftCourseClassData
  class MergeData
    def self.run(collections, orchestrator)
      PeoplesoftCourseClassData::StepProfiler.log("merge data starting.")
      courses = []
      collections.each_with_object(courses) do |course_aspect, courses|
        if found_course = courses.detect { |course| course_aspect == course}
          found_course.merge(course_aspect)
          courses << found_course
        else
          courses << course_aspect
        end
      end
      PeoplesoftCourseClassData::StepProfiler.log("merge data completed.")
      courses
    end
  end
end
