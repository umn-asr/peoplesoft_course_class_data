require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class CampusTermCourses < Resource
      def self.attributes
        [:campus, :term]
      end

      def self.child_collections
        [:courses]
      end

      configure_attributes(attributes + child_collections)

      private
      def json_attributes
        super - [:type]
      end
    end
  end
end