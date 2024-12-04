module PeoplesoftCourseClassData
  module XmlParser
    class Rows
      def initialize(doc)
        self.doc = doc
      end

      def rows
        noko_rows.map { |row| row_class.new(row, NAMESPACE) }
      end

      private

      attr_accessor :doc

      def row_class
        raise "Children must implement"
      end

      def noko_rows
        doc.xpath("//ns:row", "ns" => NAMESPACE)
      end
    end
  end
end
