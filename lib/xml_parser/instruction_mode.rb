module PeoplesoftCourseClassData
  module XmlParser
    class InstructionMode < Resource
      def self.attributes
        [:instruction_mode_id, :description]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end
