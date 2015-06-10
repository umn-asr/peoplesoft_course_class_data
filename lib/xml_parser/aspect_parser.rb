module PeoplesoftCourseClassData
  module XmlParser
    class AspectParser
      def self.parse(node_set, row_parser)
        self.new(node_set, row_parser).courses
      end

      def initialize(node_set, row_parser)
        self.node_set = node_set
        self.row_parser = row_parser
      end

      def courses
        @courses ||= parsed_rows.map { |r| PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r) }
      end

      private

      attr_accessor :node_set, :row_parser

      def parsed_rows
        @parsed_rows ||= row_parser.new(node_set).rows
      end
    end
  end
end
