require 'rails_helper'

RSpec.describe CreateBatchForDataloadJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(dataload:) }

  let(:dataload) { create(:dataload) }

  describe '#perform' do
    it 'enqueues the job' do
      expect { job }.to have_enqueued_job(described_class).with(dataload:)
    end

    it 'enqueues the callback job' do
      expect { job.perform_now }.to have_enqueued_job(CreateDatafilesInDataverseCallbackJob)
    end
  end
end
