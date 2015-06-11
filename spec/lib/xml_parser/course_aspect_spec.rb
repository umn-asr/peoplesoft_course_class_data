describe PeoplesoftCourseClassData::XmlParser::CourseAspect do
  describe ".type" do
    it "is 'course'" do
      expect(described_class.type).to eq('course')
    end
  end

  describe "==" do
    it "returns true if course_id is equal" do
      course1 = described_class.new({course_id: 1, title: "Long Title"})
      course2 = described_class.new({course_id: 1, description: "Description"})
      expect(course1 == course2).to be_truthy
    end

    it "returns false if the course_id is not equal" do
      course1 = described_class.new({course_id: 1, title: "Long Title"})
      course3 = described_class.new({course_id: 2, title: "Long Title"})
      expect(course1 == course3).to be_falsey
    end
  end

  describe "merge" do
    describe "has an attribute in the other course aspect that doesn't exist in current course aspect" do
      it "will set the current course aspect's attribute to the other course aspect attribute" do
        course1 = described_class.new({course_id: 1, sections: [], course_attributes: []})
        course2 = described_class.new({course_id: 1, title: "Long Title", sections: [], course_attributes: []})

        course1.merge(course2)

        expect(course1.title).to eq(course2.title)
      end
    end

    describe "has an attribute that exists in current but not in the other course aspect" do
      it "will  leave the the attribute in the current course aspect as is" do
        course1 = described_class.new({course_id: 1, title: "Descriptive Title", sections: [], course_attributes: []})
        course2 = described_class.new({course_id: 1, sections: [], course_attributes: []})

        original_title = course1.title

        course1.merge(course2)

        expect(course1.title).to eq(original_title)
      end
    end

    describe "has an empty string in the other course aspect attribute and a value in the current course aspect" do
      it "will leave the attribute in the current course aspect as is" do
        course1 = described_class.new({course_id: 1, title: "Descriptive Title", sections: [], course_attributes: []})
        course2 = described_class.new({course_id: 1, title: "", sections: [], course_attributes: []})

        original_title = course1.title

        course1.merge(course2)

        expect(course1.title).to eq(original_title)
      end
    end

    describe "has an empty string in the current course aspect attribute and a value in the other course aspect" do
      it "will set the value to the other course attribute value" do
        course1 = described_class.new({course_id: 1, title: "", sections: [], course_attributes: []})
        course2 = described_class.new({course_id: 1, title: "Other has Title", sections: [], course_attributes: []})

        course1.merge(course2)

        expect(course1.title).to eq(course2.title)
      end
    end

    describe "different values for the course aspect attribute" do
      it "will leave the attribute in the current course aspect as is" do
        course1 = described_class.new({course_id: 1, title: "Course Title", sections: [], course_attributes: []})
        course2 = described_class.new({course_id: 1, title: "Other has Title", sections: [], course_attributes: []})

        original_title = course1.title

        course1.merge(course2)

        expect(course1.title).to eq(original_title)
      end
    end
  end
end
