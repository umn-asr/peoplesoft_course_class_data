require_relative 'instructor'
require_relative 'instructors'
require_relative 'combined_section'
require_relative 'combined_sections'

require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class Section < Resource
      def self.attributes
        [:class_number, :number, :component]
      end

      def self.child_collections
        [:instructors, :combined_sections]
      end

      configure_attributes(attributes + child_collections)

    end
  end
end