module PeoplesoftCourseClassData
  class Services
    def self.all
      [PeoplesoftCourseClassData::ClassService, PeoplesoftCourseClassData::CourseService]
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), "services", "*.rb")) { |file| require file }
