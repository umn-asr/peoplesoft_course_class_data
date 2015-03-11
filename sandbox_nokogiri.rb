require 'nokogiri'

module QasResults
  NAMESPACE = 'http://xmlns.oracle.com/Enterprise/Tools/schemas/QAS_QUERYRESULTS_XMLP_RESP.VERSION_1'
end

class QasRow
  ROW_ATTRIBUTES = {
    course_id: {
      xml_field:  'A.CRSE_ID',
      type:       'string'
    },
    catalog_number: {
      xml_field:  'A.CATALOG_NBR',
      type:       'string'
    },
    start_date: {
      xml_field: 'A.START_DT',
      type:      'date'
    }
  }

  ROW_ATTRIBUTES.each do | method_name, config |
    define_method(method_name) do
      self.send config[:type], raw_value(config[:xml_field])
    end
  end

  def initialize(node_set)
    self.node_set = node_set
  end

  private
  attr_accessor :node_set

  def raw_value(xml_field)
    node_set.xpath("ns:#{xml_field}", 'ns' => QasResults::NAMESPACE).text
  end

  def string(value)
    String(value)
  end

  def date(value)
    Time.new(*value.split('-'))
  end

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
