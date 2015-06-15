module PeoplesoftCourseClassData
  class Grouping
    def self.group(collections)
      new(collections)
    end

    def initialize(*collections)
      self.items = collections.flatten
    end

    def by(attribute)
      group_values = items.map(&attribute).uniq
      group_values.map do |group_value|
        items.select { |item| item.send(attribute) == group_value }
      end
    end

    private
    attr_accessor :items
  end
end