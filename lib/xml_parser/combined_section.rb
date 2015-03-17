module PeoplesoftCourseClassData
  module XmlParser
    class CombinedSection

      attr_reader :catalog_number
      def initialize(catalog_number)
        self.catalog_number = catalog_number
      end

      def ==(other)
        self.catalog_number == other.catalog_number
      end

      def hash
        catalog_number.hash
      end

      def merge(other)
        #noop - this is a leaf
      end

      private
      attr_writer :catalog_number
    end
  end
end