module PeoplesoftCourseClassData
  module XmlParser
    class ClassRows
      def initialize(doc)
        self.doc = doc
      end

      def rows
        noko_rows.map { |row| ClassRow.new(row, NAMESPACE) }
      end

      private
      attr_accessor :doc

      def noko_rows
        doc.xpath('//ns:row', 'ns' => NAMESPACE)
      end
    end
  end
end
