module PeoplesoftCourseClassData
  module XmlParser

    class CourseAspectBuilder

      RESOURCES = {
          CombinedSection => "combined_section",
          Location        => "location",
          Instructor      => "instructor",
          GradingBasis    => "grading_basis",
          InstructionMode => "instruction_mode",
          CleAttribute    => "cle_attribute",
          Equivalency     => "equivalency",
          Subject         => "subject"
      }

      RESOURCES.each do | class_name, method_name |
        define_method(method_name) do
          build_resource(class_name, row_values_for(method_name))
        end
      end


      def self.build_from_row(row)
        new(row).build
      end

      def initialize(row)
        self.row = row
      end

      def build
        course_aspect
      end

      def course_aspect

        build_resource(CourseAspect, row_values_for("course") + [subject, equivalency, cle_attribute, section])
      end

      def section
        build_resource(Section, row_values_for("section") + [instruction_mode, grading_basis, instructor, meeting_pattern, combined_section])
      end

      def meeting_pattern
        meeting_attributes = row_values_for("meeting_pattern")
        meeting_attributes << location
        meeting_attributes = meeting_attributes[0..-3] + meeting_attributes[-2..-1].reverse
        build_resource(MeetingPattern, meeting_attributes)
      end


      private
      attr_accessor :row

      def build_resource(klass, arguments)
        klass.new(*arguments) unless no_info(arguments)
      end

      def no_info(arguments)
        all_nil?(arguments) || all_empty_strings?(arguments)
      end

      def all_nil?(arguments)
        arguments.compact.uniq.empty?
      end

      def all_empty_strings?(arguments)
        arguments.reduce(true) { |result, argument| result && (argument == '') }
      end

      def row_values_for(snake_case_resource)
        methods_for(snake_case_resource).map { |row_method| row.send row_method }
      end

      def methods_for(snake_case_resource)
        method_mapping.select { |_, v| v[-2] == snake_case_resource }.keys
      end

      def method_mapping
        row_methods.inject({}) { |hash, method| hash[method]=method.to_s.split('__'); hash }
      end

      def row_methods
        row.class.instance_methods - Object.instance_methods
      end

    end
  end
end