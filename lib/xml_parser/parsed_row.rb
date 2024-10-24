module PeoplesoftCourseClassData
  module XmlParser
    class ParsedRow
      ROW_MAPPING = {}

      def self.configure(config_hash = self::ROW_MAPPING)
        config_hash.each do |method_name, method_config|
          define_method(method_name) do
            converted_value(method_config)
          end
        end
      end

      def initialize(node_set, namespace = nil)
        self.node_set = node_set
        self.namespace = namespace
      end

      private

      attr_accessor :node_set, :namespace

      def converted_value(config)
        send conversion_method(config[:type]), xml_value(config[:xml_field])
      end

      def xml_value(xml_field)
        if namespace
          node_set.xpath("//ns:#{xml_field}", "ns" => namespace).text
        else
          node_set.xpath("//#{xml_field}").text
        end
      end

      def conversion_method(type)
        type || :string
      end

      def float(value)
        Float(value)
      end

      def integer(value)
        Integer(value)
      end

      def string(value)
        String(value)
      end

      def date(value)
        Time.new(*value.split("-"))
      end
    end
  end
end
