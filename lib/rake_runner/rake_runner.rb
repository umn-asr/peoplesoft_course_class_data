require 'open3'

module RakeRunner
  class RakeRunner
    class RakeError < StandardError; end

    def run(cmd)
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        if has_error?(stderr)
          raise_error(stderr)
        end
      end
    end

    private
    def has_error?(stderr)
      !stderr.eof?
    end

    def raise_error(stderr)
      raise RakeError.new(stderr.read)
    end
  end
end