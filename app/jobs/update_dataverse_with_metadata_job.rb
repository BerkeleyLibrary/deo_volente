# frozen_string_literal: true

# job to call the Dataverse API and add a single file
class UpdateDataverseWithMetadataJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default

  def perform(datafile:)
    doi = batch.properties[:dataload].bare_doi
    datafile.create_dataverse_object(doi:)
  end
end
