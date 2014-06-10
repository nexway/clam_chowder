require 'clam_chowder/backend'
require 'clam_chowder/response'

require 'clamd'

module ClamChowder
  module Backend
    class Clamd
      def initialize
        @clamd = ::Clamd::Client.new
      end

      def scan_file(path)
        parse_response(@clamd.scan(path))
      end

      private

      def parse_response(str)
        /^(?<file_path>.*): (?<virus_name>.*)\s?(?<status>(OK|FOUND))$/ =~ str
        case status
        when 'OK'
          ClamChowder::Response.new(status, file_path)
        when "FOUND"
          ClamChowder::Response.new(status, file_path, virus_name.strip)
        else
          raise ScanException.new(str)
        end
      end
    end
  end
end
