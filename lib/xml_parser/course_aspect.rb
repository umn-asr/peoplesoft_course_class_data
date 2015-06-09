module PeoplesoftCourseClassData
  module XmlParser
    class CourseAspect < Resource
      def self.attributes
        [:course_id, :catalog_number, :description, :title, :subject, :equivalency, :course_title_long, :offer_frequency]
      end

      def self.child_collections
        [:course_attributes, :sections]
      end

      def self.type
        "course"
      end

      def ==(other)
        return false unless self.class == other.class
        self.course_id == other.course_id
      end
      alias_method :eql?, :==

      configure_attributes(attributes + child_collections)
    end
  end
end