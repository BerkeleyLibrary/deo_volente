# frozen_string_literal: true

require 'spec_helper'

module DataverseService
  describe Mountpoints do
    subject(:mountpoints) { described_class.new }

    let(:config) do
      { source: { foo: { path: '/srv/foo', label: 'Foo!' }, bar: { path: '/var/bar', label: 'Bar?' } },
        destination: '/opt/dv' }
    end

    before do
      allow(Rails.application.config.x).to receive(:method_missing).with(:mountpoints).and_return(config)
      allow(Rails.application.config.x.mountpoints).to receive(:method_missing)
        .with(:source).and_return(config[:source])
      allow(Rails.application.config.x.mountpoints).to receive(:method_missing)
        .with(:destination).and_return(config[:destination])
    end

    describe '#initialize' do
      it 'creates a new instance' do
        expect(mountpoints.instance_variable_get(:@config)).to eq(config)
      end
    end

    describe '#source' do
      it 'returns the source when configured' do
        expect(mountpoints.source).to match(a_hash_including(:foo, :bar))
      end
    end

    describe '#destination' do
      it 'returns the destination when configured' do
        expect(mountpoints.destination).to eq(config[:destination])
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    # the
    describe '#method_missing' do
      it 'responds to #[source] calls' do
        expect(mountpoints).to respond_to(:foo, :bar)
        expect(mountpoints.foo).to eq(config[:source][:foo])
      end

      it 'responds to #[source]_path calls' do
        expect(mountpoints).to respond_to(:foo_path)
        expect(mountpoints.foo_path).to eq(config[:source][:foo][:path])
      end

      it 'responds to #[source]_label calls' do
        expect(mountpoints).to respond_to(:bar_label)
        expect(mountpoints.bar_label).to eq(config[:source][:bar][:label])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
