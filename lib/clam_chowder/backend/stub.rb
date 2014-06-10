require 'clam_chowder/backend/clamd'
require 'clam_chowder/response'

module ClamChowder
  module Backend
    class Stub
      def scan_file(path)
        if File.open(path, encoding: 'BINARY') {|f| f.each_line.grep(/virus/).empty? }
          ClamChowder::Response.new('OK', path)
        else
          ClamChowder::Response.new('FOUND', path, 'stub-virus')
        end
      end
    end
  end
end
