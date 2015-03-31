require 'delegate'

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Float < SimpleDelegator
        def json_tree
          to_s.gsub(/\.0\Z/,'')
        end
      end
    end
  end
end