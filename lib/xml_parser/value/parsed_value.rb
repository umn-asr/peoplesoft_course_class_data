require 'delegate'

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class ParsedValue < SimpleDelegator
        def eql?(other)
          if self.class == other.class
            __getobj__.==(other.__getobj__)
          else
            super
          end
        end
      end
    end
  end
end