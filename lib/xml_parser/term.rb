module PeoplesoftCourseClassData
  module XmlParser
    class Term < Resource
      def self.attributes
        [:term_id, :strm]
      end

      configure_attributes(attributes)
    end
  end
end