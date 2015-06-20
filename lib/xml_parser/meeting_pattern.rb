module PeoplesoftCourseClassData
  module XmlParser
    class MeetingPattern < Resource
      def self.attributes
        [:start_time, :end_time, :start_date, :end_date, :location]
      end

      def self.child_collections
        [:days]
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
