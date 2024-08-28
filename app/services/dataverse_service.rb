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

    def find_dataset(id, with_doi: true)
      request(http_method: :get, endpoint: build_request_uri('api/datasets', id, with_doi:))
    end

    def find_dataset_by_doi(doi)
      ## TODO: these are the primary methods we'll need,
      # def get_dataset; end
      # def add_file; end
      # def add_files; end
    end

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

    def build_request_uri(resource, id, submethod: nil, with_doi: true)
      did = dataset_id_or_doi(id, with_doi:)
      path = "#{resource}/#{did[:id_path]}"
      path += "/#{submethod}" unless submethod.nil?
      path += "?#{did[:query]}" unless did[:query].nil?
      path
    end

    def dataset_id_or_doi(id, with_doi: true)
      return { id_path: ':persistentId', query: "persistentId=#{id}" } if with_doi

      { id_path: id, query: nil }
    end
  end
end
