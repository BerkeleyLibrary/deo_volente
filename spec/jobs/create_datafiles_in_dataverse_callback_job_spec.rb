require 'rails_helper'

RSpec.describe CreateDatafilesInDataverseCallbackJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:batch) { GoodJob::Batch.enqueue(dataload: create(:dataload_with_datafiles)) }

  describe '#perform' do
    it 'enqueues the job' do
      expect { job.perform_later(batch, {}) }.to have_enqueued_job(described_class)
    end

    it 'enqueues the following job' do
      expect { job.perform_now(batch, {}) }.to have_enqueued_job(UpdateDataverseWithMetadataJob).exactly(5).times
    end

    it 'enqueues the callback job' do
      expect { job.perform_now(batch, {}) }.to have_enqueued_job(CleanupCallbackJob).exactly(:twice)
    end
  end
end
