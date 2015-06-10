module PeoplesoftCourseClassData
  module XmlParser
    class Equivalency < Resource
      def self.attributes
        [:equivalency_id]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
