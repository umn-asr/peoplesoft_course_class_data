module PeoplesoftCourseClassData
  module XmlParser
    class AspectParser
      def self.parse(node_set, row_parser, term, campus)
        self.new(node_set, row_parser, term, campus).aspects
      end

      def initialize(node_set, row_parser, term, campus)
        self.node_set = node_set
        self.row_parser = row_parser
        self.term = term
        self.campus = campus
      end

      def courses
        @courses ||= parsed_rows.map { |r| PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r) }
      end

      def aspects
        @aspects ||= begin
          parsed_rows.map do |r|
            course_aspect = PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r)
            PeoplesoftCourseClassData::XmlParser::CampusTermCourses.new(campus: campus, term: term, courses: [course_aspect])
          end
        end
      end

      private

      attr_accessor :node_set, :row_parser, :term, :campus

      def parsed_rows
        @parsed_rows ||= row_parser.new(node_set).rows
      end
    end
  end
end
