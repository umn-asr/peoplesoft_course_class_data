require_relative 'resource'

module PeoplesoftCourseClassData
  module XmlParser
    class CombinedSection < Resource
       def self.attributes
         [:catalog_number, :subject_id, :section_number]
       end

       def self.child_collections
         []
       end

       configure_attributes(attributes + child_collections)
    end
  end
end