# frozen_string_literal: true

# job to call the Dataverse API and add a single file
class UpdateDataverseWithMetadataJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default

  def perform(datafile:)
    client = DataverseService::APIClient.new
    # @todo better error handling
    rsp = client.add_file(batch.properties[:dataload].bare_doi, datafile)
    response_df = rsp.dig(:body, :data, :files)
    if response.dig(:body, :status) == 'OK' && !response_df.nil?
      dataverseId = response_df.first.dig(:dataFile, :id)
      datafile.update!(dataverseId:, status: :completed)
    else
      datafile.update!(status: :failed)
      raise StandardError, "Datafile #{datafile.filename} did not upload successfully; response: #{rsp[:body].as_json}"
    end
  end
end
