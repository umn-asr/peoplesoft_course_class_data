require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class Subject < Resource
      def self.attributes
        [:subject_id, :description]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
