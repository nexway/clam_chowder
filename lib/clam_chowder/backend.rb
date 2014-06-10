require 'clam_chowder/backend/clamd'
require 'clam_chowder/backend/stub'

module ClamChowder
  module Backend
    class << self
      def add(name, klass)
        @backends ||= {}

        @backends[name] = klass
      end

      def lookup(name)
        @backends[name]
      end
    end

    add(:clamd, ::ClamChowder::Backend::Clamd)
    add(:stub,  ::ClamChowder::Backend::Stub)
  end
end
