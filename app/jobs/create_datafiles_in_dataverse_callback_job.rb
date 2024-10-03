# frozen_string_literal: true

# callback job to create datafiles in dataverse
class CreateDatafilesInDataverseCallbackJob < ApplicationJob
  queue_as :default

  def perform(batch, _context)
    batch.properties[:dataload].datafiles.find_all do |datafile|
      batch.add { UpdateDataverseWithMetadataJob.perform_later(datafile:) }
    end
    batch.enqueue(on_success: 'CleanupCallbackJob', on_finish: 'CleanupCallbackJob')
  end
end
