require 'delegate'

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class String < SimpleDelegator
        def json_tree
          __getobj__
        end
      end
    end
  end
end