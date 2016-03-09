module PeoplesoftCourseClassData
  module XmlParser
    class Instructor < Resource
      def self.attributes
        [:name, :email, :role, :print]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
