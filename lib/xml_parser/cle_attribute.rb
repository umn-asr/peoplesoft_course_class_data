require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class CleAttribute < Resource
      def self.attributes
        [:attribute_id, :family]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end