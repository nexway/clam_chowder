require 'clam_chowder/scanner'

module ClamChowder
  class ScanException < StandardError; end

  class << self
    attr_accessor :default_backend

    def infected_stream?(io)
      response = Scanner.new(default_backend).scan_io(io)
      response.infected?
    rescue => e
      raise ScanException.new(e)
    end
  end

  self.default_backend = :clamd
end
