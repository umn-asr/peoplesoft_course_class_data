module PeoplesoftCourseClassData
  module XmlParser
    class Rows
      def initialize(doc)
        self.doc = doc
      end

      def rows
        noko_rows.map { |row| Row.new(row) }
      end

      private
      attr_accessor :doc

      def noko_rows
        doc.xpath('//ns:row', 'ns' => NAMESPACE)
      end
    end
  end
end