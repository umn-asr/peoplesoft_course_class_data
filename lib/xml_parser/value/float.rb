module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class Float < Value::ParsedValue
        def json_tree
          to_s.gsub(/\.0\Z/, "")
        end
      end
    end
  end
end
