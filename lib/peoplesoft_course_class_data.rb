# Your starting point for daemon specific classes. This directory is
# already included in your load path, so no need to specify it.

Dir.glob(File.join(File.dirname(__FILE__), "", "*.rb")) { |file| require file }
