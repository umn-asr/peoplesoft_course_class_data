RSpec.describe PeoplesoftCourseClassData::Grouping do
  let(:values) { (10..99).to_a.take(rand(3..7)) }
  let(:collections) do
    number_of_collections = rand(3..6)
    number_of_collections.times.map do
      10.times.map { OpenStruct.new(some_attribute: values.sample) }
    end
  end

  subject { described_class.new(*collections) }

  describe "#by" do
    it "returns an enumerable" do
      expect(subject.by(:some_attribute)).to respond_to(:each)
    end

    it "contains enumerables" do
      subject.by(:some_attribute).each do |group|
        expect(group).to respond_to(:each)
      end
    end

    it "has a collection for each unique value of the supplied attribute" do
      number_of_groupings = collections.flatten.map { |item| item.send(:some_attribute) }.uniq.count
      expect(subject.by(:some_attribute).count).to eq(number_of_groupings)
    end

    it "all members of the collection share that value" do
      subject.by(:some_attribute).each do |grouped_collection|
        expect(grouped_collection.map(&:some_attribute).uniq.count).to eq(1)
      end
    end

    it "values are not shared across collections" do
      all_values = subject.by(:some_attribute).map { |sub_collection| sub_collection.first.some_attribute }
      unique_values = subject.by(:some_attribute).map { |sub_collection| sub_collection.first.some_attribute }.uniq
      expect(all_values).to eq(unique_values)
    end
  end

  describe ".group" do
    it "builds a new Grouping with the supplied collections" do
      expect(described_class).to receive(:new).with(collections)
      described_class.group(collections)
    end
  end
end
