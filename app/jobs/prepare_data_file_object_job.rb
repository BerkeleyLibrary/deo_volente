# prepare the necessary metadata for a file for Dataverse
class PrepareDatafileObjectJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default
  # @todo make sure you understand globalid
  def perform(orig_filename:, dataload:)
    datafile = DatafileBuilder.call(orig_filename:, dataload:)
    # @todo is this the right #perform variant?
    batch.add { CopyFileToDataverseMountJob.perform_later(datafile:) }
  end
end
