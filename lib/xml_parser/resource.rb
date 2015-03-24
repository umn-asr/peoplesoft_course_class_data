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
          my_collection     = self.send(collection)
          other_collection  = other.send(collection)

          merge_matching_items(my_collection, other_collection)
          add_new_items(my_collection, other_collection)
        end
        self
      end

      def to_json
        json_tree.to_json
      end

      def json_tree
        json_attributes.each_with_object({}) do |attribute, hash|
          value = self.public_send(attribute)
          if value.respond_to?(:json_tree)
            value = value.json_tree
          end
          hash[attribute] = value
        end
      end

      def type
        self.class.type
      end

      private

      def merge_matching_items(my_collection, other_collection)
        matching_items = my_collection & other_collection
        matching_items.each do |matched_item|
          my_version = my_collection.detect { |item| item == matched_item }
          other_version  = other_collection.detect { |item| item == matched_item }
          my_version.merge(other_version)
        end
      end

      def add_new_items(my_collection, other_collection)
        new_items = other_collection - my_collection
        my_collection.merge(new_items)
      end

      def json_attributes
        ([:type] + self.class.attributes + self.class.child_collections).reject { |attribute| self.public_send(attribute).nil? }
      end
    end
  end
end