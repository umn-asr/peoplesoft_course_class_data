require 'forwardable'

module PeoplesoftCourseClassData
  module XmlParser
    class ResourceCollection
      extend Forwardable
      include Enumerable

      # attr_reader :resources
      def_delegators :resources, :each, :empty?, :&, :-

      def initialize(resources)
        self.resources = Set.new
        add(resources)
      end

      def merge(other)
        self.class.new(resources.merge(other))
      end

      def json_tree
        map(&:json_tree)
      end

      private
      attr_accessor :resources

      def add(other)
        return unless other

        if other.respond_to?(:each)
          resources.merge(other)
        else
          resources.add(other)
        end
      end
    end
  end
end