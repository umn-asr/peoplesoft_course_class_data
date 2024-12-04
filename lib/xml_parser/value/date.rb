module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Date < Value::ParsedValue
        def json_tree
          strftime("%Y-%m-%d")
        end
      end
    end
  end
end
