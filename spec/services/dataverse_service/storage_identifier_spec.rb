# frozen_string_literal: true

require 'spec_helper'

module DataverseService
  describe StorageIdentifier do
    let(:sid) do
      described_class.new(id: '12345678', driver: 'cool-uri', separator: ':', prefix: 'moo', prefix_separator: '_')
    end

    describe '::generate' do
      it 'generates a new storage identifier' do
        allow(Process).to receive(:clock_gettime).with(Process::CLOCK_REALTIME, :millisecond).and_return(1600000000000)
        allow(SecureRandom).to receive(:uuid).and_return('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')
        expect(described_class.generate).to eq("#{1600000000000.to_s(16)}-aaaaaaaaaaaa")
      end
    end

    describe '#new' do
      it 'creates a new instance with a correctly formatted ID' do
        storage_id = described_class.new
        expect(storage_id.instance_variable_get(:@id)).to match(/^\h{10,}-\h{12}/)
      end

      it 'creates a new instance if given a default value and parameters' do
        expect(sid.instance_variable_get(:@prefix)).to eq('moo')
      end
    end

    describe '#to_s' do
      it 'returns a string version of the storage identifier' do
        expect(sid.to_s).to be_a(String).and eq('12345678')
      end
    end

    describe '#to_uri' do
      it 'returns a correctly formatted URI containing all components' do
        expect(sid.to_uri).to eq('cool-uri:moo_12345678')
      end
    end
  end
end
