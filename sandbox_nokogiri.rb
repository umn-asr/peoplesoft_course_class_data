require 'nokogiri'

module QasResults
  NAMESPACE = 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1'
end

class QasRow

  def initialize(node_set)
    self.node_set = node_set
  end

  def subject
    node_set.xpath('ns:A.SUBJECT', 'ns' => QasResults::NAMESPACE).text
  end

  private
  attr_accessor :node_set

end

class QasRows
  def initialize(doc)
    self.doc = doc
    # self.rows = build_rows(doc)
  end

  def rows
    noko_rows.map { |row| QasRow.new(row) }
  end

  def noko_rows
    doc.xpath('//ns:row', 'ns' => QasResults::NAMESPACE)
  end

  private
  attr_accessor :doc
end


def noko_doc
  f = File.open('noko_xml.xml')
  doc = Nokogiri::XML(f)
  f.close

  doc
end

def rows(doc)
  QasRows.new(doc).rows
end
