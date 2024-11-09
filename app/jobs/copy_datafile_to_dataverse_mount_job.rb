# frozen_string_literal: true

# job to copy files from source directory to Dataverse files mount
class CopyDatafileToDataverseMountJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default

  def perform(datafile:, dest_fn:)
    datafile.copy_to_dataverse_directory(dest_fn:)
  end
end
