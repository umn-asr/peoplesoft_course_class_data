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
        course__repeatable: {
          xml_field:  'A.CRSE_REPEATABLE'
        },
        course__repeat_limit: {
          xml_field:  'A.CRSE_REPEAT_LIMIT',
          type:       'integer'
        },
        course__units_repeat_limit: {
          xml_field:  'A.UNITS_REPEAT_LIMIT',
          type:       'float'
        },
        course__catalog_number: {
          xml_field:  'B.CATALOG_NBR'
        },
        course__description: {
          xml_field: 'A.DESCRLONG'
        },
        course__credits_minimum: {
          xml_field:  'A.UNITS_MINIMUM',
          type:       'float'
        },
        course__credits_maximum: {
          xml_field:  'A.UNITS_MAXIMUM',
          type:       'float'
        },
        course__course_attribute__attribute_id: {
          xml_field:  'F.CRSE_ATTR_VALUE'
        },
        course__course_attribute__family: {
          xml_field:  'F.CRSE_ATTR'
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
