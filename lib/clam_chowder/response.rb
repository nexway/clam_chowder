module ClamChowder
  class Response
    attr_reader :virus_name, :file_path

    def initialize(status, file_path, virus_name = nil)
      @status     = status
      @file_path  = file_path
      @virus_name = virus_name
    end

    def infected?
      @status == 'FOUND'
    end
  end
end
