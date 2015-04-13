module PeoplesoftCourseClassData
  module XmlParser
    class CourseAspect < Resource
      def self.attributes
        [:course_id, :catalog_number, :description, :title, :subject, :equivalency]
      end

      def self.child_collections
        [:course_attributes, :sections]
      end

      def self.type
        "course"
      end

      configure_attributes(attributes + child_collections)
    end
  end
end