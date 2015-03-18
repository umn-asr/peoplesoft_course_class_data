require_relative 'cle_attribute'
require_relative 'combined_section'
require_relative 'equivalency'
require_relative 'grading_basis'
require_relative 'instruction_mode'
require_relative 'instructor'
require_relative 'meeting_pattern'
require_relative 'section'
require_relative 'subject'
require_relative 'location'
require_relative 'course_aspect'

module PeoplesoftCourseClassData
  module XmlParser

    class CourseAspectBuilder

      RESOURCES = {
          CombinedSection => "combined_section",
          # Day             => "day",
          Location        => "location",
          ## MeetingPattern  => "meeting_pattern",
          Instructor      => "instructor",
          GradingBasis    => "grading_basis",
          InstructionMode => "instruction_mode",
          ## Section         => "section",
          CleAttribute    => "cle_attribute",
          Equivalency     => "equivalency",
          Subject         => "subject"
      }

      RESOURCES.each do | class_name, method_name |
        define_method(method_name) do
          class_name.send :new, *row_values_for(method_name)
        end
      end


      def self.build_from_row(row)
        new(row).build
      end

      def initialize(row)
        self.row = row
      end

      def build
        # meeting_pattern = MeetingPattern.new(row_values_for("meeting_pattern"), location)
        #
        # section = meeting_pattern = MeetingPattern.new(row_values_for("meeting_pattern"), location)
        #
        # CourseAspect.new(row_values_for("course_aspect"), subject, equivalency, cle_attribute, section)
        course_aspect
      end

      def course_aspect
        CourseAspect.new(*row_values_for(nil), subject, equivalency, cle_attribute, section)
      end

      def section
        Section.new(*row_values_for("section"), instruction_mode, grading_basis, instructor, meeting_pattern, combined_section)
      end

      def meeting_pattern
        MeetingPattern.new(*row_values_for("meeting_pattern"), location)
      end


      private
      attr_accessor :row

      def resources
        # {
        #   CombinedSection => "combined_section",
        #   # Day             => "day",
        #   Location        => "location",
        #   MeetingPattern  => "meeting_pattern",
        #   Instructor      => "instructor",
        #   GradingBasis    => "grading_basis",
        #   InstructionMode => "instruction_mode"
        #   Section         => "section",
        #   CleAttribute    => "cle_attribute",
        #   Equivalency     => "equivalency",
        #   Subject         => "subject"
        #
        # }
      end

      def row_values_for(snake_case_resource)
        methods_for(snake_case_resource).map { |row_method| row.send row_method }
      end

      def methods_for(snake_case_resource)
        method_mapping.select { |_, v| v[-2] == snake_case_resource }.keys
      end

      def method_mapping
        row.class::ROW_ATTRIBUTES.keys.inject({}) { |hash, method| hash[method]=method.to_s.split('__'); hash }
      end


    end
  end
end