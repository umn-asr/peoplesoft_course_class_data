module PeoplesoftCourseClassData
  module XmlParser
    class CourseAspect < Resource
      def self.attributes
        [
          :course_id, :catalog_number, :description, :title, :repeatable, :repeat_limit, :units_repeat_limit,
          :offer_frequency, :credits_minimum, :credits_maximum,
          :subject, :equivalency, :grading_basis
        ]
      end

      def self.child_collections
        [:course_attributes, :sections]
      end

      configure_attributes(attributes + child_collections)

      def self.type
        "course"
      end

      def ==(other)
        return false unless self.class == other.class
        self.course_id == other.course_id
      end
      alias_method :eql?, :==

      def merge(other)
        merge_attributes(other)
        super
      end

      private

      def merge_attributes(other)
        blank_attributes.each do |attribute|
          self.send("#{attribute}=", other.send(attribute))
        end
      end

      def blank_attributes
        self.class.attributes.select { |attribute| self.send(attribute).nil? || self.send(attribute) == '' }
      end
    end
  end
end
