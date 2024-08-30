# frozen_string_literal: true

require 'spec_helper'
require 'webmock'

module DataverseService
  ### stubbed out from our TIND API gem
  # RSpec.shared_examples 'a missing key' do |bad_key|
  #   before do
  #     expect(BerkeleyLibrary::TIND::Config).to receive(:api_key).and_return(bad_key)
  #   end

  #   it "raises #{API::APIKeyNotSet}" do
  #     failure_message = -> { "#{API::APIKeyNotSet} not raised for API key #{bad_key.inspect}" }
  #     expect { API.get('some-endpoint') }.to raise_error(API::APIKeyNotSet), failure_message
  #   end
  # end

  # RSpec.shared_examples 'a missing base URL' do |bad_url|
  #   before do
  #     allow(BerkeleyLibrary::TIND::Config).to receive(:base_uri).and_return(bad_url)
  #   end

  #   it "raises #{API::APIKeyNotSet}" do
  #     failure_message = -> { "#{API::BaseURINotSet} not raised for API key #{bad_url.inspect}" }
  #     expect { API.get('some-endpoint') }.to raise_error(API::BaseURINotSet), failure_message
  #   end
  # end

  describe APIClient do
    let(:base_uri) { 'https://dataverse.oski.cat/' }
    let(:api_key) { 'sator-arepo-tenet-opera-rotas' }

    describe :initialize
    describe :find_dataset
    describe :add_file do
      it 'sends metadata for a single file'
      it 'sends metadata for a batch of files'
    end
  end
end
