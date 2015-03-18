require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class Section < Resource
      def self.attributes
        [:class_number, :number, :component, :location, :credits_minimum, :credits_maximum, :notes, :instruction_mode, :grading_basis]
      end

      def self.child_collections
        [:instructors, :meeting_patterns, :combined_sections]
      end

      configure_attributes(attributes + child_collections)

    end
  end
end