require_relative 'value/parsed_value'
Dir.glob(File.join(File.dirname(__FILE__), "value", "*.rb")) { |file| require file }
