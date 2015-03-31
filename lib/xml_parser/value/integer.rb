require 'delegate'

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Integer < SimpleDelegator
        def json_tree
          to_s
        end
      end
    end
  end
end