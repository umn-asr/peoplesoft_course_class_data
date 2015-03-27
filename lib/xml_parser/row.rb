module PeoplesoftCourseClassData
  module XmlParser
    class Row
      ROW_ATTRIBUTES = {
        course_id: {
          xml_field:  'A.CRSE_ID'
        },
        catalog_number: {
          xml_field:  'A.CATALOG_NBR'
        },
        description: {
          xml_field: 'EXPR1_1'
        },
        title: {
          xml_field:  'A.DESCR1'
        },
        subject__subject_id: {
          xml_field:  'A.SUBJECT'
        },
        subject__description: {
          xml_field:  'A.DESCR'
        },
        equivalency__equivalency_id: {
          xml_field:  'A.EQUIV_CRSE_ID'
        },
        cle_attribute__attribute_id: {
          xml_field:  'A.UM_CRSE_ATT_VAL'
        },
        cle_attribute__family: {
          xml_field:  'A.UM_CRSE_ATTR'
        },
        section__class_number: {
          xml_field:  'A.CLASS_NBR'
        },
        section__number: {
          xml_field:  'A.CLASS_SECTION'
        },
        section__component: {
          xml_field:  'A.SSR_COMPONENT'
        },
        section__location: {
          xml_field:  'A.LOCATION'
        },
        section__credits_minimum: {
          xml_field:  'A.UNITS_MINIMUM',
          type:       'float'
        },
        section__credits_maximum: {
          xml_field:  'A.UNITS_MAXIMUM',
          type:       'float'
        },
        section__notes: {
          xml_field:  'EXPR67_67'
        },
        section__instruction_mode__instruction_mode_id: {
          xml_field:  'A.INSTRUCTION_MODE'
        },
        section__instruction_mode__description: {
          xml_field:  'A.DESCR2'
        },
        section__grading_basis__grading_basis_id: {
          xml_field:  'A.GRADING_BASIS'
        },
        section__grading_basis__description: {
          xml_field:  'A.XLATLONGNAME'
        },
        section__instructor__name: {
          xml_field:  'A.NAME_DISPLAY'
        },
        section__instructor__email: {
          xml_field:  'A.EMAIL_ADDR'
        },
        section__instructor__role: {
          xml_field:  'A.INSTR_ROLE'
        },
        section__meeting_pattern__start_time: {
          xml_field:  'A.MEETING_TIME_START'
        },
        section__meeting_pattern__end_time: {
          xml_field:  'A.MEETING_TIME_END'
        },
        section__meeting_pattern__start_date: {
          xml_field:  'A.START_DT',
          type:       'date'
        },
        section__meeting_pattern__end_date: {
          xml_field:  'A.END_DT',
          type:       'date'
        },
        section__meeting_pattern__location__location_id: {
          xml_field:  'A.FACILITY_ID'
        },
        section__meeting_pattern__location__description: {
          xml_field:  'A.DESCR3'
        },
        section__combined_section__catalog_number: {
          xml_field:  'A.CATALOG_NBR_SRCH1'
        },
        section__combined_section__subject_id: {
          xml_field:  'A.SUBJECT_SRCH1'
        },
        section__combined_section__section_number: {
          xml_field:  'A.UM_CLASS_SECTION'
        }
      }

      ROW_ATTRIBUTES.each do | method_name, config |
        define_method(method_name) do
          self.send type_conversion(config), xml_value(config)
        end
      end

      def initialize(node_set, namespace)
        self.node_set = node_set
        self.namespace = namespace
      end

      def section__meeting_pattern__days
        day_elements = %w[A.MON A.TUES A.WED A.UM_THURS A.FRI A.SAT A.UM_SUNDAY]
        day_elements.reject { |day_element| raw_value(day_element).empty? }.map { |active_day| Days.for_xml_tag(active_day) }
      end

      private
      attr_accessor :node_set, :namespace
      def type_conversion(config)
        config[:type] || 'string'
      end

      def xml_value(config)
        raw_value(config[:xml_field])
      end

      def raw_value(xml_field)
        node_set.xpath("ns:#{xml_field}", 'ns' => namespace).text
      end

      def string(value)
        String(value)
      end

      def integer(value)
        Integer(value)
      end

      def float(value)
        Float(value)
      end

      def date(value)
        Time.new(*value.split('-'))
      end
    end
  end
end