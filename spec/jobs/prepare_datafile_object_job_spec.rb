# frozen_string_literal: true

require 'rails_helper'

SANDBOX_DIR = 'spec/support/sandbox'

RSpec.describe PrepareDatafileObjectJob, type: :job do
  include ActiveJob::TestHelper
  subject(:job) do
    GoodJob::Batch.enqueue { described_class.perform_later(orig_filename:, dataload:) }
  end

  let(:dataload) { create(:dataload) }
  let(:orig_filename) { '/opt/app/spec/support/sandbox/foobar/WJJIYL.json' }

  before do
    @old_pwd = Dir.pwd
    FileUtils.mkdir_p(SANDBOX_DIR)
    FileUtils.cp_r('spec/data', "#{SANDBOX_DIR}/foobar")
  end

  after do
    Dir.chdir(@old_pwd)
    FileUtils.rm_rf(SANDBOX_DIR)
  end

  describe '#perform' do
    it 'enqueues the job' do
      expect { job }.to have_enqueued_job(described_class).with(orig_filename:, dataload:)
    end

    # @todo figure out how to test batch queuing. as is, it fails as
    #       expected to enqueue exactly 1 jobs, but enqueued 0
    it 'enqueues a job from a batch', pending: 'the mysteries of batch enqueuing' do
      expect { job }.to have_enqueued_job(CopyDatafileToDataverseMountJob)
    end
  end
end
