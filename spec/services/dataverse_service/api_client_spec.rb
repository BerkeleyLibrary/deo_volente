# frozen_string_literal: true

require 'spec_helper'

module DataverseService
  describe ApiClient do
    let(:key) { 'sator-arepo-tenet-opera-rotas' }
    let(:doi) { 'doi:10.60503/D3/WJJIYL' }

    describe '#initialize' do
      it 'sets base URI and API key from environment variables' do
        allow(ENV).to receive(:[]).with('DATAVERSE_BASE_URI').and_return('https://dv.ucberk.li/')
        allow(ENV).to receive(:[]).with('DATAVERSE_API_KEY').and_return(key)

        client = described_class.new
        expect(client.instance_variable_get(:@api_key)).to eq(key)
      end

      it 'sets base URI and API key from arguments' do
        client = described_class.new(base_uri: 'https://dataverse.oski.cat/', api_key: key)
        expect(client.instance_variable_get(:@base_uri)).to eq('https://dataverse.oski.cat/')
      end
    end

    context 'with defined client' do
      let(:client) { described_class.new(base_uri: 'https://dv.ucberk.li/', api_key: key) }

      describe '#find_dataset' do
        it 'retrieves the metadata by DOI for a dataset if it exists in Dataverse' do # rubocop:disable RSpec/ExampleLength
          stub_request(:get, "https://dv.ucberk.li/api/datasets/:persistentId?persistentId=#{doi}")
            .with(headers: { 'X-Dataverse-key': key })
            .to_return(status: 200,
                       headers: { 'Content-type': 'application/json' },
                       body: File.read('spec/data/WJJIYL.json'))
          dataset = client.find_dataset(doi)
          expect(dataset).to match(a_hash_including(status: 200,
                                                    body: a_hash_including(
                                                      status: 'OK', data: a_hash_including(id: 36487)
                                                    )))
        end # rubocop:enable RSpec/ExampleLength

        it 'retrieves the metadata by Dataverse ID for a dataset if it exists in Dataverse' do # rubocop:disable RSpec/ExampleLength
          stub_request(:get, 'https://dv.ucberk.li/api/datasets/36487')
            .with(headers: { 'X-Dataverse-key': key })
            .to_return(status: 200,
                       headers: { 'Content-type': 'application/json' },
                       body: File.read('spec/data/WJJIYL.json'))
          dataset = client.find_dataset('36487', with_doi: false)
          expect(dataset).to match(a_hash_including(status: 200,
                                                    body: a_hash_including(
                                                      status: 'OK', data: a_hash_including(identifier: 'D3/WJJIYL')
                                                    )))
        end # rubocop:enable RSpec/ExampleLength

        it 'returns an error if the dataset does not exist' do
          stub_request(:get, 'https://dv.ucberk.li/api/datasets/3000')
            .with(headers: { 'X-Dataverse-key': key })
            .to_return(status: 404,
                       headers: { 'Content-type': 'application/json' },
                       body: File.read('spec/data/404.json')).and_raise(Faraday::ResourceNotFound)
          expect { client.find_dataset('3000', with_doi: false) }.to raise_error(Faraday::ResourceNotFound)
        end
      end

      # @todo dry this up
      describe '#add_file' do
        let(:headers) { { 'X-Dataverse-key': key, 'Content-Type' => %r{\Amultipart/form-data} } }
        let(:metadata) do
          { storageIdentifier: 'file://1919b0e566c-4043d5358e16', fileName: '1.zip', mimeType: 'application/zip',
            md5Hash: '55e7ad34a79df7aa9e81252a3e7dc817', description: '' }
        end

        it 'successfully adds a single file when not yet registered in Dataverse' do # rubocop:disable RSpec/ExampleLength
          stub_request(:post, "https://dv.ucberk.li/api/datasets/:persistentId/add?persistentId=#{doi}")
            .with(headers: { 'X-Dataverse-key': key }) { |request| # rubocop:disable Style/BlockDelimiters
            boundary = request.headers['Content-Type'].match(/boundary=(.*)/)[1]
            json_part = <<~PART.strip
              --#{boundary}
              Content-Disposition: form-data; name="jsonData"
              Content-Type: application/json

              #{metadata.to_json}
              --#{boundary}
            PART

            std_new_line_body = request.body.gsub("\r\n", "\n")
            std_new_line_body.include?(json_part)
          }
          .to_return(status: 200,
                     headers: { 'Content-type': 'application/json' },
                     body: File.read('spec/data/single_file_response.json'))
          expect(client.add_file(doi,
                                 metadata:))
            .to match(a_hash_including(status: 200,
                                       body: a_hash_including(data: a_hash_including(:files))))
        end # rubocop:enable RSpec/LineLength

        it 'fails adding a single file when it is already registered in Dataverse' do # rubocop:disable RSpec/ExampleLength
          stub_request(:post, "https://dv.ucberk.li/api/datasets/:persistentId/add?persistentId=#{doi}")
            .with(headers: { 'X-Dataverse-key': key }) { |request| # rubocop:disable Style/BlockDelimiters
            boundary = request.headers['Content-Type'].match(/boundary=(.*)/)[1]
            json_part = <<~PART.strip
              --#{boundary}
              Content-Disposition: form-data; name="jsonData"
              Content-Type: application/json

              #{metadata.to_json}
              --#{boundary}
            PART

            std_new_line_body = request.body.gsub("\r\n", "\n")
            std_new_line_body.include?(json_part)
          }.to_return(status: 400,
                      headers: { 'Content-type': 'application/json' },
                      body: File.read('spec/data/single_file_error.json')).and_raise(Faraday::BadRequestError)
          expect { client.add_file(doi, metadata:) }.to raise_error(Faraday::BadRequestError)
          # @todo add something like:
          # .and match(a_hash_including(status: 400, body: a_hash_including(message: /Failed to add file to dataset/)))
        end # rubocop:enable RSpec/ExampleLength

        # @todo add a spec to test if adding batches of files works
      end
    end
  end
end
