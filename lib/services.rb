module PeoplesoftCourseClassData
  class Services
    def self.all
      [PeoplesoftCourseClassData::ClassService, PeoplesoftCourseClassData::CourseService]
    end
  end
end