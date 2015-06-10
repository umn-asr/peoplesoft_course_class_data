require_relative 'xml_parser'

module PeoplesoftCourseClassData
  module XmlParser
    class CourseParser < AspectParser
      private

      def row_parser
        PeoplesoftCourseClassData::XmlParser::CourseRows
      end
    end
  end
end
