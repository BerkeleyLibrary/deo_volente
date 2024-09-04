# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'

# module to contain application services for Dataverse API calls
module DataverseService
  # API client to interact with Dataverse for out of band uploads
  class APIClient
    attr_accessor :base_uri, :api_key

    # constructor for DataverseService::APIClient
    #
    # @param [String] base_uri the base uri to the Dataverse server
    # @param [String] api_key the dataverse API key
    #
    # @todo Raise an exception if args are not includedd
    def initialize(base_uri: nil, api_key: nil)
      @api_key = ENV['DATAVERSE_API_KEY'] || api_key
      @base_uri = ENV['DATAVERSE_BASE_URI'] || base_uri
    end

    # retrieves metadata for a given dataset
    #
    # @params [String] id id the ID for the resource in question, either a database ID or a DOI
    # @params [Boolean] with_doi specifies whether `id` is a DOI or not
    def find_dataset(id, with_doi: true)
      request(http_method: :get, endpoint: build_request_uri('api/datasets', id, with_doi:))
    end

    # adds a file to an existing Dataverse dataset. implementation
    # assumes that this is an out of band upload.
    #
    # @todo catch errors so we can provide a more useful one in logs
    #
    # @see https://guides.dataverse.org/en/latest/developers/s3-direct-upload-api.html#adding-the-uploaded-file-to-the-dataset
    def add_file(id, metadata: nil)
      method = metadata.is_a?(Array) ? 'addFiles' : 'add'
      payload = { jsonData: Faraday::Multipart::ParamPart.new(metadata.to_json, 'application/json') }
      request(http_method: :post,
              endpoint: build_request_uri('api/datasets',
                                          id,
                                          submethod: method),
              body: payload)
    end

    alias add_files add_file

    private

    # private method to wrap the Dataverse API
    def client
      @client ||= begin
        options = { headers: { 'X-Dataverse-key': @api_key } }
        Faraday.new(url: @base_uri, **options) do |config|
          config.request :multipart, **options
          config.request :json
          config.response :json, parser_options: { symbolize_names: true }
          config.response :raise_error
          config.response :logger, Rails.logger, headers: true, bodies: true, log_level: :debug
        end
      end
    end

    # private method to send requests to Faraday
    #
    # @param [Symbol] http_method the HTTP method of the request
    # @param [String] endpoint the API endpoint the request will be sent to
    # @param [Hash,Array,String] the body of the request to send
    def request(http_method:, endpoint:, body: {})
      response = client.public_send(http_method, endpoint, body)
      { status: response.status, body: response.body }
    end

    # private method to build a Dataverse API call, depending on
    # how a Dataset ID is passed (DOI or dataset ID)
    #
    # @params [String] resource the Dataverse resource type
    # @params [String] id the ID for the resource in question
    # @params [String, NilClass] submethod the submethod for the resource
    # @params [Boolean] with_doi pecifies whether `id` is a DOI or not
    def build_request_uri(resource, id, submethod: nil, with_doi: true)
      did = dataset_id_or_doi(id, with_doi:)
      path = "#{resource}/#{did[:id_path]}"
      path += "/#{submethod}" unless submethod.nil?
      path += "?#{did[:query]}" unless did[:query].nil?
      path
    end

    # private method to construct a URI part and query string depending
    # on whether the Dataset ID is a database ID or DOI
    #
    # @params [String] id id the ID for the resource in question, either a database ID or a DOI
    # @params [Boolean] with_doi specifies whether `id` is a DOI or not
    def dataset_id_or_doi(id, with_doi: true)
      return { id_path: ':persistentId', query: "persistentId=#{id}" } if with_doi

      { id_path: id, query: nil }
    end
  end
end
