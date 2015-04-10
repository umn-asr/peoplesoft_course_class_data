module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class String < Value::ParsedValue
        def json_tree
          __getobj__
        end
      end
    end
  end
end