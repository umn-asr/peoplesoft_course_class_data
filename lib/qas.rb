module PeoplesoftCourseClassData
  module Qas
    class SoapEnvError < StandardError; end
  end
end
Dir.glob(File.join(File.dirname(__FILE__), "qas", "*.rb")) { |file| require file }
