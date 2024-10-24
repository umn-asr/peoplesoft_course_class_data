require_relative "../../lib/services"

RSpec.describe PeoplesoftCourseClassData::Services do
  describe ".all" do
    it "contains ClassService" do
      expect(described_class.all).to include(PeoplesoftCourseClassData::ClassService)
    end

    it "contains CourseService" do
      expect(described_class.all).to include(PeoplesoftCourseClassData::CourseService)
    end

    it "does not return anything else" do
      expect(described_class.all.count).to eq(2)
    end
  end
end
