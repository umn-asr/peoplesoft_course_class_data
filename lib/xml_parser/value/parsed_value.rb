require "delegate"

module PeoplesoftCourseClassData
  module XmlParser
    module Value
      class ParsedValue < SimpleDelegator
        def ==(other)
          __getobj__.==(other)
        end

        def eql?(other)
          if self.class == other.class
            __getobj__.==(other.__getobj__)
          else
            super
          end
        end

        def hash
          __getobj__.hash
        end
      end
    end
  end
end
