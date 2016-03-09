module PeoplesoftCourseClassData
  module XmlParser
    class Section < Resource
      def self.attributes
        [:class_number, :number, :component, :location, :notes, :status, :enrollment_cap, :instruction_mode]
      end

      def self.child_collections
        [:instructors, :meeting_patterns, :combined_sections]
      end

      configure_attributes(attributes + child_collections)

    end
  end
end
