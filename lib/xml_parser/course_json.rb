require_relative 'xml_parser'

module PeoplesoftCourseClassData
  module XmlParser
    class CourseJson
      def self.parse(node_set)
        self.new(node_set).courses
      end

      def initialize(node_set)
        self.node_set = node_set
      end

      def courses
        modeled_rows
      end

      private

      attr_accessor :node_set

      def modeled_rows
        @modeled_rows ||= parsed_rows.map { |r| PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r) }
      end

      def parsed_rows
        @parsed_rows ||= PeoplesoftCourseClassData::XmlParser::CourseRows.new(node_set).rows
      end
    end
  end
end
