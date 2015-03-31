require_relative 'xml_parser'
require_relative '../file_names'

module PeoplesoftCourseClassData
  module XmlParser
    class ClassJson
      def initialize(file_to_convert)
        self.file_to_convert = file_to_convert
      end

      def to_file
        File.open(json_file, 'w+') do |f|
          f.write(xml_to_json)
        end
      end

      private
      attr_accessor :file_to_convert

      def xml_to_json
        json_resource.to_json
      end

      def json_resource
        PeoplesoftCourseClassData::XmlParser::CampusTermCourses.new(campus, term, courses)
      end

      def courses
        course_ids = modeled_rows.map(&:course_id).uniq

        course_ids.map do |course_id|
          course_rows = modeled_rows.select { |row| row.course_id == course_id }
          course = course_rows.inject(:merge)
          course
        end
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
        file      = File.open(file_to_convert)
        node_set  = Nokogiri::XML(file) do |config|
                      config.default_xml.noblanks
                    end
        file.close
        node_set
      end

      def campus
        PeoplesoftCourseClassData::XmlParser::Campus.new(file_names.campus, file_names.campus)
      end

      def term
        PeoplesoftCourseClassData::XmlParser::Term.new(file_names.term, file_names.term)
      end

      def json_file
        file_names.json_with_path
      end

      def file_names
        @file_names = ::PeoplesoftCourseClassData::FileNames.from_file_name(file_to_convert)
      end
    end
  end
end
