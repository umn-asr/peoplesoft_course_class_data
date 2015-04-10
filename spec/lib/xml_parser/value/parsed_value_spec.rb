require_relative '../../../../lib/xml_parser/value/parsed_value'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::ParsedValue do
  describe "equality checks" do
    it "meets array uniquness requirements" do
      ["a string", 42, 98.6, Time.now].each do |value|
        array = rand(3..7).times.map { described_class.new(value) }
        expect(array.uniq).to eq([described_class.new(value)])
      end
    end

    it "meets set uniquness requirements" do
      ["a string", 42, 98.6, Time.now].each do |value|
        set = Set.new
        rand(3..7).times { set.add(described_class.new(value)) }
        expect(set).to eq(Set.new([described_class.new(value)]))
      end
    end
  end
end