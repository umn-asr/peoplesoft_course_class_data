require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class Instructor < Resource
      def self.attributes
        [:name, :email, :role]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
