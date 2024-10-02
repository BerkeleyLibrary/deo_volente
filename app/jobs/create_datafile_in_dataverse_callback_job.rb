class CreateDatafileInDataverseCallbackJob < ApplicationJob
  queue_as :default

  def perform(batch, context)
    client = DataverseService::APIClient.new
    batch.properties[:dataload].datafiles.find_in_batches(batch_size: 100) do |group|
      # create a new job with a list of ids for serialization
      # within the new job:
      #   serialize
      #   create the files in dataverse
      #   update the datafile objects in deo_volente
      # callback to handle after all batches?
    end
  end
end
