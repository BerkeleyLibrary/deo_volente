# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CopyDatafileToDataverseMountJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(datafile:, dest_fn:) }

  let(:datafile) do
    dataload = create(:dataload_with_datafiles)
    dataload.datafiles.first
  end

  let(:dest_fn) { "/tmp/dv_#{SecureRandom.alphanumeric}" }

  describe '#perform' do
    it 'enqueues the job' do
      expect { job }.to have_enqueued_job(described_class).with(datafile:, dest_fn:)
    end
  end
end
