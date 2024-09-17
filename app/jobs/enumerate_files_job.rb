# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class EnumerateFilesJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches
  queue_as :default

  def perform(*args)
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
end
