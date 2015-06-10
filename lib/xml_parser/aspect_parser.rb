require_relative 'xml_parser'

module PeoplesoftCourseClassData
  module XmlParser
    class AspectParser
      def self.parse(node_set)
        self.new(node_set).courses
      end

      def initialize(node_set)
        self.node_set = node_set
      end

      def courses
        @courses ||= parsed_rows.map { |r| PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r) }
      end

      private

      attr_accessor :node_set

      def parsed_rows
        @parsed_rows ||= row_parser.new(node_set).rows
      end

      def row_parser
        raise 'Child must implement'
      end
    end
  end
end
