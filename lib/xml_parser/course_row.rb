module PeoplesoftCourseClassData
  module XmlParser
    class CourseRow
      ROW_ATTRIBUTES = {
        course__course_id: {
          xml_field:  'B.CRSE_ID'
        },
        course__course_title_long: {
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

      def initialize(node_set, namespace)
        self.node_set = node_set
        self.namespace = namespace
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
        Value::String.new(String(value))
      end

      def integer(value)
        Value::Integer.new(Integer(value))
      end

      def float(value)
        Value::Float.new(Float(value))
      end

      def date(value)
        Value::Date.new(Time.new(*value.split('-')))
      end
    end
  end
end
