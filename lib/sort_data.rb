require_relative 'workflow'

module PeoplesoftCourseClassData
  class SortData
    def self.run(parsed_data, orchestrator)
      sorted_data = parsed_data.flatten.to_set.classify { |course_aspect| course_aspect.course_id }.values
      orchestrator.run_step(MergeData, sorted_data)
    end
  end
end