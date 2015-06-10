require_relative 'xml_parser'

module PeoplesoftCourseClassData
  module XmlParser
    class ClassParser < AspectParser
      private

      def row_parser
        PeoplesoftCourseClassData::XmlParser::ClassRows
      end
    end
  end
end
