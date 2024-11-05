require 'rails_helper'

RSpec.describe CopyDatafileToDataverseMountJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }
  
  describe '#perform' do
    it 'enqueues the job'
  end
