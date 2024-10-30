require 'rails_helper'

RSpec.describe CreateBatchForDataloadJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(dataload:) }

  let(:dataload) { create(:dataload) }

  before do
    FakeFS do
      FakeFS::FileSystem.clone('spec/data', '/srv/da/foobar')
    end
  end

  describe '#perform' do
    it 'queues the job' do
      expect { job }.to have_enqueued_job(described_class)
    end

    it 'creates a batch of jobs' do
    end
  end
  # it 'creates a batch'
  #   (this job is enqueued)
  #   given director of x files, it enqueues 1 batch
  #   and that batch should have x jobs
  #   after enqueued, thec callback should be enqued
end
