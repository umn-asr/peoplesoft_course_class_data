require 'forwardable'

module PeoplesoftCourseClassData
  module XmlParser
    class ResourceCollection
      extend Forwardable
      include Enumerable

      def_delegator :resources, :each

      attr_reader :resources

      def initialize(resources)
        self.resources = Set.new
        add(resources)
      end

      def merge(other)
        self.class.new(resources.merge(other.resources))
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