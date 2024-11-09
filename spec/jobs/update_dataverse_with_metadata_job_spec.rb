require 'rails_helper'

RSpec.describe UpdateDataverseWithMetadataJob, type: :job do
  subject(:job) { described_class.perform_later(datafile:, doi:) }

  let(:datafile) { create(:datafile_with_dataload) }

  let(:doi) { '10.1000/RST/NLE' }

  describe '#perform' do
    it 'enqueues the job' do
      expect { job }.to have_enqueued_job(described_class).with(datafile:, doi:)
    end
  end
end
