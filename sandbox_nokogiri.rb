require 'nokogiri'

module QasResults
  NAMESPACE = 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1'
end

class QasRow
  def initialize(node_set)
    self.node_set = node_set
  end

  def course_id
    node_set.xpath('ns:A.CATALOG_NBR', 'ns' => QasResults::NAMESPACE).text
  end

  def catalog_number
    node_set.xpath('ns:A.CATALOG_NBR', 'ns' => QasResults::NAMESPACE).text
  end

  def subject
    node_set.xpath('ns:A.SUBJECT', 'ns' => QasResults::NAMESPACE).text
  end

  def start_date
    node_set.xpath('ns:A.START_DT', 'ns' => QasResults::NAMESPACE).text
  end

  def start_time
    node_set.xpath('ns:A.MEETING_TIME_START', 'ns' => QasResults::NAMESPACE).text
  end

  def end_time
    node_set.xpath('ns:A.MEETING_TIME_END', 'ns' => QasResults::NAMESPACE).text
  end

  def subject_description

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


def noko_doc(file_name = 'afro_hist_physics.xml')
  f = File.open(file_name)
  doc = Nokogiri::XML(f) do |config|
    config.default_xml.noblanks
  end
  f.close

  doc
end

def rows(doc = noko_doc)
  QasRows.new(doc).rows
end
