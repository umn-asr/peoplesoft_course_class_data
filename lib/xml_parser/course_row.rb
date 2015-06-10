module PeoplesoftCourseClassData
  module XmlParser
    class CourseRow < Row
      ROW_ATTRIBUTES = {
        course__course_id: {
          xml_field:  'B.CRSE_ID'
        },
        course__title: {
          xml_field:  'A.COURSE_TITLE_LONG'
        },
        course__offer_frequency: {
          xml_field:  'K.DESCR'
        },
      }

      ROW_ATTRIBUTES.each do | method_name, config |
        define_method(method_name) do
          self.send type_conversion(config), xml_value(config)
        end
      end
    end
  end
end
