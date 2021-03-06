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

      def initialize(args = {})
        args.each do |key, value|
          if self.class.child_collections.include?(key)
            self.send "#{key}=", ResourceCollection.new(value)
          else
            self.send "#{key}=", value
          end
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
          hash[attribute] = value.json_tree
        end
      end

      def type
        Value::String.new(self.class.type)
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
