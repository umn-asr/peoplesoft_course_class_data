RSpec.describe PeoplesoftCourseClassData::XmlParser::Resource do

  describe ".configure_attributes" do
    let(:attributes) { [:attribute_id, :description] }

    class ConfigureMyAttributes < described_class; end

    before do
      ConfigureMyAttributes.configure_attributes(attributes)
    end

    subject { ConfigureMyAttributes.new }

    it "adds public getters for each item" do
      attributes.each do |attribute|
        expect(subject).to respond_to(attribute)
      end
    end

    it "adds private setters for each item" do
      attributes_and_setters = attributes.inject({}) { |hash, attribute| hash[attribute]= "#{attribute.to_s}=".to_sym; hash}

      attributes_and_setters.each do |attribute, setter|
        value = rand(1..10)
        subject.send setter, value
        expect(subject.send attribute).to eq(value)
        expect(subject).not_to respond_to("#{attribute}=")
      end
    end
  end

  describe ".new" do
    class Book < described_class;
      def self.attributes
        [:book_id, :title]
      end

      def self.child_collections
        [:chapters, :appendices]
      end

      configure_attributes(attributes + child_collections)
    end

    let(:id)          { rand(100..999) }
    let(:title)       { id.next.to_s }
    let(:chapters)    { rand(10..20).times.map { Object.new } }
    let(:appendices)  { rand(1..5).times.map { Object.new }   }

    it "assigns arguments to the attributes" do
      subject = Book.new(book_id: id, title: title)
      expect(subject.book_id).to eq(id)
      expect(subject.title).to eq(title)
    end

    it "builds ResourceCollections for attributes in child_collections" do
      subject = Book.new(book_id: id, title: title, chapters: chapters, appendices: appendices)

      expect(subject.chapters.entries).to eq(chapters.entries)
      expect(subject.appendices.entries).to eq(appendices.entries)
    end

  end


  describe "equality" do
    subject { TestInstructor.new(name: 'Jane Schmoe', email: 'jane@umn.edu') }
    context "when the other has the same attribute values" do
      let(:other) { TestInstructor.new(name: 'Jane Schmoe', email: 'jane@umn.edu') }

      it "is equal" do
        expect(subject).to eql(other)
        expect(subject).to be == other
      end

      it "passes set equality" do
        set = Set.new [subject]
        expect(set).to include(other)
      end

      it "passes set uniqueness" do
        set = Set.new [subject]
        expect(set.merge([other]).count).to eq 1
      end
    end

    context "when the other has a different attribute" do
      let(:other_name)  { TestInstructor.new(name: 'Joe Schmoe', email: 'jane@umn.edu') }
      let(:other_email) { TestInstructor.new(name: 'Jane Schmoe', email: 'joe@umn.edu') }
      let(:other_all)   { TestInstructor.new(name: 'Joe Schmoe', email: 'joe@umn.edu') }

      it "is not equal" do
        [other_name, other_email, other_all].each do |other|
          expect(subject).not_to eq(other)
        end
      end
    end

    context "when the other is a different class" do
      class Contact < described_class
        def self.attributes
          [:name, :email]
        end

        def self.child_collections
          []
        end

        configure_attributes(attributes + child_collections)
      end

      let(:different_class_instance) { Contact.new(name: 'Jane Schmoe', email: 'jane@umn.edu') }
      it "is not equal" do
        expect(subject).not_to eq(different_class_instance)
      end
    end

    it "can make comparisons to nil" do
      expect(subject).not_to eq(nil)
    end
  end

  describe "#merge" do
    let(:jane)              { TestInstructor.new(name: 'Jane Schmoe', email: 'jane@umn.edu') }
    let(:joe)               { TestInstructor.new(name: 'Joe Schmoe', email: 'joe@umn.edu') }
    let(:combined_3456)     { TestCombinedSection.new(catalog_number: '3456') }
    let(:combined_5120)     { TestCombinedSection.new(catalog_number: '5120') }
    let(:jane_joe_lecture)  { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [jane, joe], combined_sections: [combined_5120]) }
    let(:jane_lab)          { TestSection.new(class_number: "26191", number: "002", component: "LAB", instructors: [jane], combined_sections: [combined_5120]) }
    let(:joe_lab)           { TestSection.new(class_number: "26191", number: "002", component: "LAB", instructors: [joe], combined_sections: [combined_5120]) }
    let(:jane_lecture)      { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [jane], combined_sections: [combined_3456]) }
    let(:joe_lecture)       { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [joe], combined_sections: [combined_3456]) }
    let(:writing_intensive) { TestCleAttribute.new(attribute_id: 'WI', family: 'CLE') }
    let(:phys_core)         { TestCleAttribute.new(attribute_id: 'PHYS', family: 'CLE') }

    context "first level merge" do
      subject { jane_lecture }

      context "when the other is not equal" do
        let(:lab)           { TestSection.new(class_number: "26191", number: "002", component: "LAB", instructors: [jane], combined_sections: [combined_3456]) }

        it "returns self" do
          expect(subject.merge(lab)).to eq(subject)
        end
      end

      context "when the other is equal" do
        context "and the other's instructor is not in the subject's collection" do
          let(:other) { joe_lecture }

          it "adds the other's instructor to the collection" do
            subject.merge(other)
            expect(subject.instructors).to include(joe)
          end

          it "leaves the combined_sections alone" do
            original_combined_sections = subject.combined_sections
            subject.merge(other)
            expect(subject.combined_sections.count).to eq(original_combined_sections.count)
            expect(subject.combined_sections).to eq(original_combined_sections)
          end
        end

        context "and the other's combined section is not in the subject's collection" do
          let (:other) { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [jane], combined_sections: [combined_5120]) }

          it "adds the other's combined section to the collection" do
            subject.merge(other)
            expect(subject.combined_sections).to include(combined_5120)
          end

          it "leaves the instructors unchanged" do
            original_instructors = subject.instructors
            subject.merge(other)
            expect(subject.instructors.count).to eq(original_instructors.count)
            expect(subject.instructors).to eq(original_instructors)
          end
        end

        context "and the other's child is in the subject's collection" do
          let(:instructor_spy) { instance_spy("Instructor", name: "Jane Schmoe", email: "jane@umn.edu") }
          let(:other) { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [instructor_spy], combined_sections: [combined_5120]) }
          subject { TestSection.new(class_number: "26191", number: "001", component: "LEC", instructors: [instructor_spy], combined_sections: [combined_5120]) }

          it "merges its child with the other's child. using spies because Rspec arg matchers do not like us overwriting == " do
            subject_jane  = subject.instructors.detect { |instructor| instructor.name == "Jane Schmoe" }
            other_jane    = other.instructors.detect { |instructor| instructor.name == "Jane Schmoe" }
            subject.merge(other)
            expect(subject_jane).to have_received(:merge).with(other_jane)
          end
        end
      end
    end

    context "a nested merge" do
      let(:subject) {
                      TestCourseAspect.new(
                                                      course_id: "002066", catalog_number: "1101W", description: "description", title: "Intro College Phys I",
                                                      sections: [jane_joe_lecture, jane_lab],
                                                      cle_attributes: [writing_intensive]
                                                    )
                                                  }
      let(:other)   {
                      TestCourseAspect.new(
                                                      course_id: "002066", catalog_number: "1101W", description: "description", title: "Intro College Phys I",
                                                      sections: [joe_lab],
                                                      cle_attributes: [writing_intensive]
                                                    )
                                                  }

      it "navigates down the tree to perform a nested merge, adding joe as a lab instructor" do
        subject_lab = subject.sections.detect { |section| section == TestSection.new(class_number: "26191", number: "002", component: "LAB") }
        expect(subject_lab.instructors).not_to include(joe)
        subject.merge(other)
        subject_lab = subject.sections.detect { |section| section == TestSection.new(class_number: "26191", number: "002", component: "LAB") }
        expect(subject_lab.instructors).to include(joe)
      end
    end

    context "a merge on a second collection" do
      let(:subject) {
                      TestCourseAspect.new(
                                            course_id: "002066", catalog_number: "1101W", description: "description", title: "Intro College Phys I",
                                            sections: [jane_joe_lecture],
                                            cle_attributes: [writing_intensive]
                                          )
                                        }
      let(:other)   {
                      TestCourseAspect.new(
                                            course_id: "002066", catalog_number: "1101W", description: "description", title: "Intro College Phys I",
                                            sections: [jane_joe_lecture],
                                            cle_attributes: [phys_core]
                                          )
                                        }

      it "adds the new item to the collection" do
        expect(subject.cle_attributes).not_to include(phys_core)
        subject.merge(other)
        expect(subject.cle_attributes).to include(phys_core)
      end

      it "maintains the old items" do
        subject.merge(other)
        expect(subject.cle_attributes).to include(writing_intensive)
      end
    end
  end

  describe "to_json" do
    context "the type key" do
      it "adds a 'type' key with the snake_cased version of the class name" do
        subject = TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Jane Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("jane@umn.edu"))

        actual_key_value_pairs    = key_value_pairs(subject.to_json)
        expected_key_value_pairs  = key_value_pairs({"type" => TestInstructor.to_s.underscore}.to_json)
        expect(actual_key_value_pairs).to include(expected_key_value_pairs)
      end

      context "when the class is namespaced" do
        class PeoplesoftCourseClassData::XmlParser::TestInstructor < described_class
          def self.attributes
            [:name, :email]
          end

          configure_attributes(attributes)
        end

        it "removes namespaces from the class name" do
          subject = PeoplesoftCourseClassData::XmlParser::TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Jane Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("jane@umn.edu"))

          actual_key_value_pairs    = key_value_pairs(subject.to_json)
          expected_key_value_pairs  = key_value_pairs({"type" => "test_instructor"}.to_json)
          expect(actual_key_value_pairs).to include(expected_key_value_pairs)
        end
      end

      context "when .type is defined on the class" do
        class CustomTypeName < described_class
          def self.attributes
            [:custom_type_name_id]
          end

          def self.type
            "something other than custom_type_name"
          end
          configure_attributes(attributes)
        end

        it "the return value of the .type method is the value of the key" do
          subject = CustomTypeName.new(custom_type_name_id: PeoplesoftCourseClassData::XmlParser::Value::Integer.new(rand(1..100)))

          actual_key_value_pairs    = key_value_pairs(subject.to_json)
          expected_key_value_pairs  = key_value_pairs({"type" => CustomTypeName.type}.to_json)
          expect(actual_key_value_pairs).to include(expected_key_value_pairs)
        end
      end
    end

    context "attributes" do
      context "when the attribute is a value" do
        subject { TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Jane Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("jane@umn.edu")) }

        it "turns the attributes into key/value pairs" do
          actual_key_value_pairs    = key_value_pairs(subject.to_json)
          expected_key_value_pairs  = key_value_pairs({"name" => "Jane Schmoe", "email" => "jane@umn.edu"}.to_json)
          expect(actual_key_value_pairs).to include(expected_key_value_pairs)
        end
      end

      context "when an attribute is a Resource" do
        class CompoundResouce < described_class
          def self.attributes
            [:compound_id, :instructor]
          end

          configure_attributes(attributes)
        end

        let(:instructor) { TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Jane Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("jane@umn.edu")) }
        let(:id)         { PeoplesoftCourseClassData::XmlParser::Value::Integer.new(rand(1..100))}

        subject { CompoundResouce.new(compound_id: id, instructor: instructor) }

        it "has the json representation of resource as the value of the attribute" do
          actual_key_value_pairs      = key_value_pairs(subject.to_json)
          key_value_pair_for_resource = key_value_pairs( { "instructor" => JSON.parse(instructor.to_json) }.to_json )
          expect(actual_key_value_pairs).to include(key_value_pair_for_resource)
        end

        context "when the attribute's value is nil" do
          subject { CompoundResouce.new(compound_id: id, instructor: nil) }

          it "does not add the key" do
            actual_key_value_pairs    = key_value_pairs(subject.to_json)
            expect(actual_key_value_pairs).not_to include("instructor")
          end
        end

      end
    end

    context "child_collections" do
      class ResourceWithChildCollection <described_class
        def self.attributes
          [:resource_id]
        end

        def self.child_collections
          [:test_instructors]
        end

        configure_attributes(attributes + child_collections)
      end

      let(:test_instructors)  { [
                                  TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Jane Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("jane@umn.edu")),
                                  TestInstructor.new(name: PeoplesoftCourseClassData::XmlParser::Value::String.new("Joe Schmoe"), email: PeoplesoftCourseClassData::XmlParser::Value::String.new("joe@umn.edu"))
                                  ] }
      let(:resource_id)   { PeoplesoftCourseClassData::XmlParser::Value::Integer.new(rand(1..100))}

      subject { ResourceWithChildCollection.new(resource_id: resource_id, test_instructors: test_instructors) }

      it "calls .json_tree on the collection" do
        expect(subject.test_instructors).to receive(:json_tree)
        subject.to_json
      end

      it "assigns the json_tree representation of the collection to that key" do
        actual_key_value_pairs    = key_value_pairs(subject.to_json)
        expected_key_value_pairs  = key_value_pairs( { "test_instructors" => subject.test_instructors.json_tree }.to_json )
        expect(actual_key_value_pairs).to include(expected_key_value_pairs)
      end
    end

    def key_value_pairs(json_string)
      json_string.gsub(/\{|\}/,'')
    end
  end

  class TestInstructor < described_class
    def self.attributes
      [:name, :email]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes + child_collections)
  end

  class TestCombinedSection < described_class
    def self.attributes
      [:catalog_number]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  class TestSection < described_class
    def self.attributes
      [:class_number, :number, :component]
    end

    def self.child_collections
      [:instructors, :combined_sections]
    end

    configure_attributes(attributes + child_collections)
  end

  class TestCleAttribute < described_class
    def self.attributes
      [:attribute_id, :family]
    end

    def self.child_collections
      []
    end

    configure_attributes(attributes)
  end

  class TestCourseAspect < described_class
    def self.attributes
      [:course_id, :catalog_number, :description, :title]
    end

    def self.child_collections
      [:sections, :cle_attributes]
    end

    configure_attributes(attributes + child_collections)
  end

end
