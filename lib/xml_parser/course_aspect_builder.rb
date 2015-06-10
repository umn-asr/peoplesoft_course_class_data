module PeoplesoftCourseClassData
  module XmlParser

    class CourseAspectBuilder

      RESOURCES = {
          CombinedSection => "combined_section",
          Location        => "location",
          Instructor      => "instructor",
          GradingBasis    => "grading_basis",
          InstructionMode => "instruction_mode",
          CourseAttribute => "course_attribute",
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

        build_resource(CourseAspect, row_values_for("course").merge(subject: subject, equivalency: equivalency, course_attributes: course_attribute, sections: section))
      end

      def section
        build_resource(Section, row_values_for("section").merge(instruction_mode: instruction_mode, grading_basis: grading_basis, instructors: instructor, meeting_patterns: meeting_pattern, combined_sections: combined_section))
      end

      def meeting_pattern
        build_resource(MeetingPattern, row_values_for("meeting_pattern").merge(location: location))
      end


      private
      attr_accessor :row

      def build_resource(klass, arguments)
        klass.new(arguments) unless no_info(arguments.values)
      end

      def no_info(values)
        all_nil?(values) || all_empty_strings?(values)
      end

      def all_nil?(values)
        values.compact.uniq.empty?
      end

      def all_empty_strings?(values)
        values.reduce(true) { |result, value| result && (value == '') }
      end

      def row_values_for(snake_case_resource)
        methods_for(snake_case_resource).inject({}) do |hash, method_mapping|
          value = (row.send method_mapping.method_name)
          hash[method_mapping.attribute] = value
          hash
        end
      end

      def methods_for(snake_case_resource)
        method_mapping.select { |mapping| mapping.resource == snake_case_resource }
      end

      def method_mapping
        row_methods.map { |row_method| MethodMapping.new(row_method) }
      end

      def row_methods
        row.class.instance_methods - Object.instance_methods
      end

    end

    class MethodMapping
      attr_reader :method_name

      def initialize(method_name)
        self.method_name = method_name
      end

      def resource
        parsed_name[-2]
      end

      def attribute
        parsed_name[-1].to_sym
      end

      private
      attr_writer :method_name

      def parsed_name
        method_name.to_s.split('__')
      end
    end

  end
end
