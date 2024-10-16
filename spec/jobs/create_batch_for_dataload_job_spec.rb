require 'rails_helper'

RSpec.describe CreateBatchForDataloadJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(args) }

  # it 'creates a batch'
  #   (this job is enqueued)
  #   given director of x files, it enqueues 1 batch
  #   and that batch should have x jobs
  #   after enqueued, thec callback should be enqued

  pending "add some examples to (or delete) #{__FILE__}"
end
