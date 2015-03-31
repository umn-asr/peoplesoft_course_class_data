require 'delegate'

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Date < SimpleDelegator
        def json_tree
          strftime('%Y-%m-%d')
        end
      end
    end
  end
end