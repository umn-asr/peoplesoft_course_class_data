require_relative 'section'
require_relative 'sections'
require_relative 'cle_attribute'
require_relative 'cle_attributes'
require_relative 'instructor'
require_relative 'instructors'
require_relative 'combined_section'
require_relative 'combined_sections'

require_relative 'resource'


module PeoplesoftCourseClassData
  module XmlParser
    class CourseAspect < Resource
      def self.attributes
        [:course_id, :catalog_number, :description, :title]
      end

      def self.child_collections
        [:sections, :cle_attributes]
      end

      configure_attributes(attributes + child_collections)
    end
  end
end