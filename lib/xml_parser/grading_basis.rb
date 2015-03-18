require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class InstructionMode < Resource
      def self.attributes
        [:grading_basis_id, :description]
      end

      def self.child_collections
        []
      end

      configure_attributes(attributes + child_collections)
    end
  end
end