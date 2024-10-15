# frozen_string_literal:true

module DataverseService
  # convenience wrapper around Dataverse storage identifier code
  class StorageIdentifier
    attr_reader :id

    def initialize(id: nil, driver: 'file', separator: '://', prefix: nil, prefix_separator: nil)
      @id = id || DataverseService::StorageIdentifier.generate
      @driver = driver
      @separator = separator
      @prefix = prefix
      @prefix_separator = prefix_separator
    end

    def to_s
      @id.to_s
    end

    def to_uri
      "#{@driver}#{@separator}#{@prefix}#{@prefix_separator}#{@id}"
    end

    def self.generate
      # get milliseconds since epoch, and convert to hex digits
      timestamp = Process.clock_gettime(Process::CLOCK_REALTIME, :millisecond)
      hex_timestamp = timestamp.to_s(16)

      # last 6 bytes of a random uuid in hex
      uuid = SecureRandom.uuid
      hex_random = uuid[24..]

      "#{hex_timestamp}-#{hex_random}"
    end

    def self.to_s(**)
      new(**).to_s
    end

    def self.to_uri(**)
      new(**).to_uri
    end
  end
end
