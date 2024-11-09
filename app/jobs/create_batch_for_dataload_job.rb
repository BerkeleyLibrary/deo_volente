# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class CreateBatchForDataloadJob < ApplicationJob
  queue_as :default

  def perform(dataload:)
    dataload.update!(status: :in_progress)
    batch = GoodJob::Batch.new
    batch.properties.merge!(dataload:, dataload_gid: dataload.to_global_id.to_s,
                            doi: dataload.doi,
                            source_path: dataload.realpath.to_s,
                            description: "Dataload #{dataload.id}: src: #{dataload.realpath}; dst: DOI #{dataload.doi}")

    Pathname.new(batch.properties[:source_path]).glob('**/*') do |f|
      batch.add { PrepareDatafileObjectJob.perform_later(orig_filename: f.to_s, dataload:) } unless File.directory?(f)
    end

    batch.enqueue(on_success: 'CreateDatafilesInDataverseCallbackJob')
  end
end
