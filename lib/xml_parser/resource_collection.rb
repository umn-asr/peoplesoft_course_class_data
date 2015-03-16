module PeoplesoftCourseClassData
  module XmlParser
    class ResourceCollection
      attr_reader :resources
      def initialize(resources)
        self.resources = Set.new
        add(resources)
      end

      def merge(other)
        self.class.new(resources.merge(other.resources))
      end

      def include?(other)
        resources.include?(other)
      end

      private
      attr_writer :resources

      def add(other)
        if other.respond_to?(:each)
          resources.merge(other)
        else
          resources.add(other)
        end
      end
    end
  end
end