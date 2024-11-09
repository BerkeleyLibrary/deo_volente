# frozen_string_literal: true

module DataverseService
  # provides accessors for the dataverse-related mountpoints
  class Mountpoints
    # instantiates an object to access mountpoint configuration
    #
    def initialize
      @config = Rails.configuration.x.mountpoints
    end

    def source
      @config.source
    end

    def destination
      @config.destination
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.end_with?('_path') || method_name.end_with?('_label') || source.key?(method_name.to_sym) || super
    end

    def method_missing(method_name, *args, &)
      if method_name.end_with?('_path')
        @config.source.dig(method_name[0..-6].to_sym, :path)
      elsif method_name.end_with?('_label')
        @config.source.dig(method_name[0..-7].to_sym, :label)
      elsif source.key?(method_name.to_sym)
        @config.source.fetch(method_name)
      else
        super
      end
    end
  end
end
