module PeoplesoftCourseClassData
  module XmlParser
    NAMESPACE = 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1'
  end
end

require 'nokogiri'

require_relative 'aspect_parser'
require_relative 'parsed_row'
require_relative 'class_row'
require_relative 'class_rows'
require_relative 'course_row'
require_relative 'course_rows'
require_relative 'value/value'
require_relative 'resource'
require_relative 'resource_collection'
require_relative 'course_attribute'
require_relative 'combined_section'
require_relative 'equivalency'
require_relative 'grading_basis'
require_relative 'instruction_mode'
require_relative 'instructor'
require_relative 'meeting_pattern'
require_relative 'section'
require_relative 'subject'
require_relative 'location'
require_relative 'course_aspect'
require_relative 'campus'
require_relative 'term'
require_relative 'campus_term_courses'
require_relative 'course_aspect_builder'
require_relative 'node_set'
