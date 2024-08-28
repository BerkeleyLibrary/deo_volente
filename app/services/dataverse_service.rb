# frozen_string_literal: true

require 'faraday'

# module to contain application services for Dataverse API calls
module DataverseService
  # API client to interact with Dataverse for out of band uploads
  class APIClient
    attr_accessor :server, :api_key

    def initialize(server: nil, api_key: nil)
      @api_key = ENV['DATAVERSE_API_KEY'] || api_key
      @server = ENV['DATAVERSE_SERVER'] || server
    end

    ## TODO: these are the primary methods we'll need,
    # def get_dataset; end
    # def add_file; end
    # def add_files; end

    private

    def client
      @client ||= begin
        options = { headers: { 'X-Dataverse-API-key': @api_key } }
        Faraday.new(url: @server, **options) do |config|
          config.request :json
          config.response :json, parser_options: { symbolize_names: true }
          config.response :raise_error
          config.response :logger, Rails.logger, headers: false, bodies: true, log_level: :debug
        end
      end
    end

    def request(http_method:, endpoint:, body: {})
      response = client.public_send(http_method, endpoint, body)
      { status: response.status, body: response.body }
    end
  end
end
