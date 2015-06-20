module PeoplesoftCourseClassData
  module XmlParser
    class NodeSet
      def self.build(xml_string)
        Nokogiri::XML(xml_string) do |config|
          config.default_xml.noblanks
        end
      end
    end
  end
end
