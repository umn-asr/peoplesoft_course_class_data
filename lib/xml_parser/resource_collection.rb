require "forwardable"

module PeoplesoftCourseClassData
  module XmlParser
    class ResourceCollection
      extend Forwardable
      include Enumerable

      def_delegators :resources, :each, :empty?, :&, :-

      def initialize(resources)
        self.resources = Set.new
        merge(resources)
      end

      def merge(other)
        return unless other

        if other.respond_to?(:each)
          resources.merge(other)
        else
          resources.add(other)
        end
      end

      def json_tree
        map(&:json_tree)
      end

      private

      attr_accessor :resources
    end
  end
end
