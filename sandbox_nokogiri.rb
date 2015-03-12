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
    description: {
      xml_field: 'EXPR1_1',
      type:      'string'
    },
    title: {
      xml_field:  'A.DESCR1',
      type:       'string'
    },
    subject_subject_id: {
      xml_field:  'A.SUBJECT',
      type:       'string'
    },
    subject_description: {
      xml_field:  'A.DESCR',
      type:       'string'
    },
    cle_attribute_family: {
      xml_field:  'A.UM_CRSE_ATTR',
      type:       'string'
    },
    cle_attribute_attribute_id: {
      xml_field:  'A.UM_CRSE_ATT_VAL',
      type:       'string'
    },
    sections_class_number: {
      xml_field:  'A.CLASS_NBR',
      type:       'string'
    },
    sections_number: {
      xml_field:  'A.CLASS_SECTION',
      type:       'string'
    },
    sections_component: {
      xml_field:  'A.SSR_COMPONENT',
      type:       'string'
    },
    sections_location: {
      xml_field:  'A.LOCATION',
      type:       'string'
    },
    sections_credits_minimum: {
      xml_field:  'A.UNITS_MINIMUM',
      type:       'integer'
    },
    sections_credits_maximum: {
      xml_field:  'A.UNITS_MAXIMUM',
      type:       'string'
    },
    sections_notes: {
      xml_field:  'EXPR67_67',
      type:       'string'
    },
    sections_instruction_mode_instruction_mode_id: {
      xml_field:  'A.INSTRUCTION_MODE',
      type:       'string'
    },
    sections_instruction_mode_description: {
      xml_field:  'A.DESCR2',
      type:       'string'
    },
    sections_grading_basis_grading_basis_id: {
      xml_field:  'A.GRADING_BASIS',
      type:       'string'
    },
    sections_grading_basis_description: {
      xml_field:  'A.XLATLONGNAME',
      type:       'string'
    },
    sections_instructors_name: {
      xml_field:  'A.NAME_DISPLAY',
      type:       'string '
    },
    sections_instructors_email: {
      xml_field:  'A.EMAIL_ADDR',
      type:       'string'
    },
    sections_instructors_role: {
      xml_field:  'A.INSTR_ROLE',
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

  def sections_meeting_patterns_days
    day_elements = %w[A.MON A.TUES A.WED A.UM_THURS A.FRI A.SAT A.UM_SUNDAY]
    day_elements.reject { |day_element| raw_value(day_element).empty? }.map { |active_day| Day.for_xml_tag(active_day) }
  end

  private
  attr_accessor :node_set

  def raw_value(xml_field)
    node_set.xpath("ns:#{xml_field}", 'ns' => QasResults::NAMESPACE).text
  end

  def string(value)
    String(value)
  end

  def integer(value)
    Integer(value)
  end

  def date(value)
    Time.new(*value.split('-'))
  end

  class Day
    class Monday
      def xml_tag
        "A.MON"
      end

      def type_name
        "monday"
      end
    end

    class Tuesday
      def xml_tag
        "A.TUES"
      end

      def type_name
        "tuesday"
      end
    end

    class Wednesday
      def xml_tag
        "A.WED"
      end

      def type_name
        "wednesday"
      end
    end

    class Thursday
      def xml_tag
        "A.UM_THURS"
      end

      def type_name
        "thursday"
      end
    end

    class Friday
      def xml_tag
        "A.FRI"
      end

      def type_name
        "firday"
      end
    end

    class Saturday
      def xml_tag
        "A.SAT"
      end

      def type_name
        "saturday"
      end
    end

    class Sunday
      def xml_tag
        "A.UM_SUNDAY"
      end

      def type_name
        "sunday"
      end
    end

    ALL_DAYS = [Day::Monday, Day::Tuesday, Day::Wednesday, Day::Thursday, Day::Friday, Day::Saturday, Day::Sunday]

    def self.for_xml_tag(xml_tag)
      ALL_DAYS.map(&:new).detect { |day| day.xml_tag == xml_tag }
    end
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
