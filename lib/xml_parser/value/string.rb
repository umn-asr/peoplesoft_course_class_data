module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class String < Value::ParsedValue
        def json_tree
          __getobj__.encode("US-ASCII", invalid: :replace, undef: :replace)
        end
      end
    end
  end
end
