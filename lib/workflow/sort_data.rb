module PeoplesoftCourseClassData
  class SortData
    def self.run(parsed_data, orchestrator)
      all_course_aspects  = parsed_data.flatten
      course_ids          = all_course_aspects.map(&:course_id).uniq.sort
      puts "course_ids: #{course_ids}"
      sorted_data         = course_ids.map do |course_id|
                              all_course_aspects.select { |course_aspect| course_aspect.course_id == course_id }
                            end
      puts "sorted_data: #{sorted_data.count}"
      orchestrator.run_step(MergeData, sorted_data)
    end
  end
end
