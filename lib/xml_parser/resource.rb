require_relative  'resource_collection'
require           'json'
require           'active_support/inflector'

module PeoplesoftCourseClassData
  module XmlParser
    class Resource

      def self.attributes
        []
      end

      def self.child_collections
        []
      end

      def self.configure_attributes(attributes)
        attributes.each do |attribute|
          puts "adding attribute #{attribute}"
          self.send(:attr_reader, attribute)
          self.send(:attr_writer, attribute)
          class_eval "private :#{attribute}="
        end
      end

      def self.type
        self.to_s.demodulize.underscore
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
        return false unless self.class == other.class

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

      def to_json
        json_tree.to_json
      end

      def json_tree
        json_hash = {"type" => self.class.type }
        (self.class.attributes + self.class.child_collections).each do |attribute|
          value = self.public_send(attribute)
          if value.respond_to?(:json_tree)
            value = value.json_tree
          end
          json_hash[attribute] = value
        end
        json_hash
      end

    end
  end
end