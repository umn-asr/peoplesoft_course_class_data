require_relative 'resource_collection'

module PeoplesoftCourseClassData
  module XmlParser
    class Resource
      def self.configure_attributes(attributes)
        attributes.each do |attribute|
          puts "adding attribute #{attribute}"
          self.send(:attr_reader, attribute)
          self.send(:attr_writer, attribute)
          class_eval "private :#{attribute}="
        end
      end

      def initialize(*args)
        self.class.attributes.each_with_index do |attribute, index|
          self.send "#{attribute}=", args[index]
        end
        self.class.child_collections.each_with_index do |collection, index|
          index_with_offset = self.class.attributes.count + index
          self.send "#{collection}=", ResourceCollection.new(args[index_with_offset])
        end
      end

      def ==(other)
        self.class.attributes.inject(true) do |result, attribute|
          result && (self.send(attribute) == other.send(attribute))
        end
      end
      alias_method :eql?, :==

      def hash
        self.class.attributes.map(&:hash).inject(:+)
      end

      def merge(other)
        self.class.child_collections.each do |collection|
          other_child      = other.send(collection).first
          matching_child   = self.send(collection).detect { |item| item == other_child }
          if matching_child
            matching_child.merge(other_child)
          else
            self.send(collection).merge(other.send(collection))
          end
        end
        self
      end

      private
    end
  end
end