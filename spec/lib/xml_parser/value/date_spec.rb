require_relative '../../../../lib/xml_parser/value/date'

RSpec.describe PeoplesoftCourseClassData::XmlParser::Value::Date do
  let(:time)  { Time.new }
  subject     { described_class.new(time) }

  describe "json_tree" do
    it "is the time in YYYY-mm-dd format" do
      expect(subject.json_tree).to eq(time.strftime('%Y-%m-%d'))
    end
  end
end