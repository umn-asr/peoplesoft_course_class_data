module PeoplesoftCourseClassData
  module XmlParser
    class Instructor
      attr_reader :name, :email

      def initialize(name, email)
        self.name   = name
        self.email  = email
      end

      def ==(other)
        (self.name == other.name) &&
        (self.email == other.email)
      end

      def hash
        name.hash + email.hash
      end

      def merge(other)
        #noop - this is a leaf
      end

      private
      attr_writer :name, :email
    end
  end
end
