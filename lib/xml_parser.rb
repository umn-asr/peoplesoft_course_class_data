module PeoplesoftCourseClassData
  module XmlParser
    NAMESPACE = "http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1"
  end
end

require "nokogiri"
require_relative "xml_parser/resource"
require_relative "xml_parser/location"
require_relative "xml_parser/combined_section"
require_relative "xml_parser/instructor"
require_relative "xml_parser/grading_basis"
require_relative "xml_parser/instruction_mode"
require_relative "xml_parser/course_attribute"
require_relative "xml_parser/equivalency"
require_relative "xml_parser/subject"
require_relative "xml_parser/row"
require_relative "xml_parser/rows"
Dir.glob(File.join(File.dirname(__FILE__), "xml_parser", "*.rb")) { |file| require file }
