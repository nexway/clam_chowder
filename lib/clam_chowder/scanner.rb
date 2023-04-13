require 'tempfile'
require 'clam_chowder'
require 'clam_chowder/backend'
require 'clam_chowder/response'

module ClamChowder
  class Scanner
    def self.infected_stream?(io)
      ::ClamChowder.infected_stream?(io) # XXX compatibility
    end

    def initialize(backend = ClamChowder.default_backend)
      @backend ||= ClamChowder::Backend.lookup(backend).new
    end

    def scan_io(readable)
      begin
        Tempfile.open('clam_chowder_temp', encoding: 'BINARY') do |file|
          while bytes = readable.read(1024 * 32)
            file.write(bytes.strip)
          end
          file.rewind
          file.chmod(0644)
          @backend.instream(file.path)
        end
      rescue => e
        raise ScanException.new(e)
      end
    ensure
      readable.rewind if readable.respond_to?(:rewind)
    end
  end
end
