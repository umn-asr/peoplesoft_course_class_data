require_relative 'xml_parser'

module PeoplesoftCourseClassData
  module XmlParser
    class ClassJson
      def self.parse(data_source)
        self.new(data_source).xml_to_json
      end

      def initialize(data_source)
        self.xml_string = data_source.data
        self.campus = data_source.campus
        self.term = data_source.term
      end

      def xml_to_json
        json_resource.to_json
      end

      private

      attr_writer :campus, :term
      attr_accessor :xml_string


      def json_resource
        PeoplesoftCourseClassData::XmlParser::CampusTermCourses.new(campus: campus, term: term, courses: courses)
      end

      def courses
        modeled_rows
      end

      def modeled_rows
        @modeled_rows ||= parsed_rows.map { |r| PeoplesoftCourseClassData::XmlParser::CourseAspectBuilder.build_from_row(r) }
      end

      def parsed_rows
        @parsed_rows ||= PeoplesoftCourseClassData::XmlParser::Rows.new(node_set).rows
      end

      def node_set
        @node_set ||= build_node_set
      end

      def build_node_set
        Nokogiri::XML(xml_string) do |config|
          config.default_xml.noblanks
        end
      end

      def campus
        campus_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(@campus)
        PeoplesoftCourseClassData::XmlParser::Campus.new(campus_id: campus_value, abbreviation: campus_value)
      end

      def term
        term_value = PeoplesoftCourseClassData::XmlParser::Value::String.new(@term)
        PeoplesoftCourseClassData::XmlParser::Term.new(term_id: term_value, strm: term_value)
      end
    end
  end
end
