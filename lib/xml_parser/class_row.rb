module PeoplesoftCourseClassData
  module XmlParser
    class ClassRow < Row
      ROW_ATTRIBUTES = {
        course__course_id: {
          xml_field:  'A.CRSE_ID'
        },
        course__catalog_number: {
          xml_field:  'A.CATALOG_NBR'
        },
        course__description: {
          xml_field: 'EXPR1_1'
        },
        course__title: {
          xml_field:  'A.DESCR1'
        },
        course__subject__subject_id: {
          xml_field:  'A.SUBJECT'
        },
        course__subject__description: {
          xml_field:  'A.DESCR'
        },
        course__equivalency__equivalency_id: {
          xml_field:  'A.EQUIV_CRSE_ID'
        },
        course__course_attribute__attribute_id: {
          xml_field:  'A.UM_CRSE_ATT_VAL'
        },
        course__course_attribute__family: {
          xml_field:  'A.UM_CRSE_ATTR'
        },
        course__section__class_number: {
          xml_field:  'A.CLASS_NBR'
        },
        course__section__number: {
          xml_field:  'A.CLASS_SECTION'
        },
        course__section__component: {
          xml_field:  'A.SSR_COMPONENT'
        },
        course__section__location: {
          xml_field:  'A.LOCATION'
        },
        course__section__credits_minimum: {
          xml_field:  'A.UNITS_MINIMUM',
          type:       'float'
        },
        course__section__credits_maximum: {
          xml_field:  'A.UNITS_MAXIMUM',
          type:       'float'
        },
        course__section__notes: {
          xml_field:  'EXPR67_67'
        },
        course__section__instruction_mode__instruction_mode_id: {
          xml_field:  'A.INSTRUCTION_MODE'
        },
        course__section__instruction_mode__description: {
          xml_field:  'A.DESCR2'
        },
        course__section__grading_basis__grading_basis_id: {
          xml_field:  'A.GRADING_BASIS'
        },
        course__section__grading_basis__description: {
          xml_field:  'A.XLATLONGNAME'
        },
        course__section__instructor__name: {
          xml_field:  'A.NAME_DISPLAY'
        },
        course__section__instructor__email: {
          xml_field:  'A.EMAIL_ADDR'
        },
        course__section__instructor__role: {
          xml_field:  'A.INSTR_ROLE'
        },
        course__section__meeting_pattern__start_time: {
          xml_field:  'A.MEETING_TIME_START'
        },
        course__section__meeting_pattern__end_time: {
          xml_field:  'A.MEETING_TIME_END'
        },
        course__section__meeting_pattern__start_date: {
          xml_field:  'A.START_DT',
          type:       'date'
        },
        course__section__meeting_pattern__end_date: {
          xml_field:  'A.END_DT',
          type:       'date'
        },
        course__section__meeting_pattern__location__location_id: {
          xml_field:  'A.FACILITY_ID'
        },
        course__section__meeting_pattern__location__description: {
          xml_field:  'A.DESCR3'
        },
        course__section__combined_section__catalog_number: {
          xml_field:  'A.CATALOG_NBR_SRCH1'
        },
        course__section__combined_section__subject_id: {
          xml_field:  'A.SUBJECT_SRCH1'
        },
        course__section__combined_section__section_number: {
          xml_field:  'A.UM_CLASS_SECTION'
        }
      }

      ROW_ATTRIBUTES.each do | method_name, config |
        define_method(method_name) do
          self.send type_conversion(config), xml_value(config)
        end
      end

      def course__section__meeting_pattern__days
        day_elements = %w[A.MON A.TUES A.WED A.UM_THURS A.FRI A.SAT A.UM_SUNDAY]
        day_elements.reject { |day_element| raw_value(day_element).empty? }.map { |active_day| Days.for_xml_tag(active_day) }
      end
    end
  end
end