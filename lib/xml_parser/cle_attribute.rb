module PeoplesoftCourseClassData
  module XmlParser
    CleAttribute = Struct.new(:attribute_id, :family) do
      def ==(other)
        (self.attribute_id == other.attribute_id) && (self.family == other.family)
      end
    end
  end
end