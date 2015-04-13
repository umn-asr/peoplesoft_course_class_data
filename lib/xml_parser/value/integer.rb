module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Integer < Value::ParsedValue
        def json_tree
          to_s
        end
      end
    end
  end
end