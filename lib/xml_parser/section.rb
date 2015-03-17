require_relative 'instructor'
require_relative 'instructors'
require_relative 'combined_section'
require_relative 'combined_sections'

require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class Section < Resource
      attr_reader :class_number, :number, :component, :instructors, :combined_sections

      def initialize(class_number, number, component, instructors = [], combined_sections = [])
        self.class_number       = class_number
        self.number             = number
        self.component          = component
        self.instructors        = Instructors.new(instructors)
        self.combined_sections  = CombinedSections.new(combined_sections)
      end

      def merge(other)
        child_collections.each do |collection|
          other_child      = other.send(collection).first
          matching_child   = self.send(collection).detect { |item| item == other_child }
          if matching_child
            matching_child.merge(other_child)
          else
            self.send(collection).merge(other.send(collection))
          end
        end
        self
      end

      def ==(other)
        (self.class_number == other.class_number) &&
          (self.number == other.number) &&
          (self.component == other.component)
      end
      alias_method :eql?, :==

      def hash
        (class_number.hash + number.hash + component.hash)
      end

      def child_collections
        [:instructors, :combined_sections]
      end

      private
      attr_writer :class_number, :number, :component, :instructors, :combined_sections
    end
  end
end