module PeoplesoftCourseClassData
  module XmlParser
    class Campus < Resource
      def self.attributes
        [:campus_id, :abbreviation]
      end

      configure_attributes(attributes)
    end
  end
end
