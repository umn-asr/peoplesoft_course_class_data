require_relative 'cle_attribute'

module PeoplesoftCourseClassData
  module XmlParser
    class CleAttributes
      attr_reader :attributes
      def initialize(attributes)
        self.attributes = Set.new
        add(attributes)
      end

      def merge(other)
        self.class.new(attributes.merge(other.attributes))
      end

      def include?(other)
        attributes.include?(other)
      end

      private
      attr_writer :attributes

      def add(other)
        if other.respond_to?(:each)
          attributes.merge(other)
        else
          attributes.add(other)
        end
      end
    end
  end
end