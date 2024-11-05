# prepare the necessary metadata for a file for Dataverse
class PrepareDatafileObjectJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default

  def perform(orig_filename:, dataload:)
    datafile = DatafileBuilder.call(orig_filename:, dataload:)
    dest_fn = Pathname(DataverseService::Mountpoints.new.destination)
              .join(dataload.path_doi,
                    datafile.directoryLabel,
                    datafile.storageIdentifier)
    batch.add { CopyDatafileToDataverseMountJob.perform_later(datafile:, dest_fn:) }
  end
end
