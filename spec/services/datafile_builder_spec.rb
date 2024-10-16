# frozen_string_literal: true

require 'spec_helper'

# look at factorybot
describe DatafileBuilder do
  include FakeFS::SpecHelpers
  describe '::call' do
    let(:orig_filename) { '/srv/da/mocks/mock1/foo/bar/baz/quux.csv' }
    let(:dataload) do
      stub_model(Dataload) do |dataload|
        dataload.directory = 'mocks/mock1'
        dataload.mountPoint = 'digital_assets'
      end
    end

    before do
      allow(dataload).to receive(:realpath).and_return(Pathname.new('/srv/da/mocks/mock1'))
    end

    it 'creates a new Datafile' do
      described_class.call(orig_filename:, dataload:)
      expect(dataload).to have_received(:datafiles)
    end
  end
end
