require 'rails_helper'

RSpec.describe CleanupCallbackJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:batch) { GoodJob::Batch.enqueue(dataload: create(:dataload_with_datafiles)) }

  describe '#perform' do
    it 'enqueues the job' do
      expect { job.perform_later(batch, {}) }.to have_enqueued_job(described_class)
    end
  end
end
