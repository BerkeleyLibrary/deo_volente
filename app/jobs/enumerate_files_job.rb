# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class EnumerateFilesJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches
  queue_as :default

  def perform(batch, context)
    batch.enqueue(stage: 1) do
      enumerate_files(mountpoint:, path:) do |f|
        PrepareDatafileObjectJob.perform_later(orig_filename: f.to_s)
      end
    end
    # 1. get the Dataload object
    # 2. get the real path:
    #   * get the :source key, and look up its :path attribute
    #   * concat the :path + '/' + the :directory attrib from Dataload
    # 3. create a GoodJob::Batch
    #   * for each file, add a new job to the batch to process that file
    #
    # realpath = Pathname.new(path).realpath
    # Pathname.glob(realpath + '**/*') do |p|
    #   Datafile.new(whatever)
    # end
  end

  def enumerate_files(mountpoint:, path:)
    source_path = DataverseService::Mountpoints.new.public_send("#{mountpoint}_path")
    Pathname.glob("#{source_path}/#{path}/**/*")
  end
end
