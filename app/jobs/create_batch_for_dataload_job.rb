# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class CreateBatchForDataloadJob < ApplicationJob
  queue_as :default

  def perform(dataload:)
    dataload.update!(status: :in_progress)
    batch = GoodJob::Batch.new
    batch.properties[:dataload] = dataload
    batch.properties[:dataload_gid] = dataload.to_global_id.to_s
    batch.properties[:doi] = dataload.doi
    batch.properties[:source_path] = dataload.realpath.to_s
    batch.description = "Dataload #{dataload.id}: source: #{dataload.realpath}; destination DOI #{dataload.doi}"
    batch.save

    batch.add do
      Pathname.new(batch.properties[:source_path]).glob('**/*') do |f|
        PrepareDatafileObjectJob.perform_later(orig_filename: f.to_s) if File.file?(f)
      end
    end

    batch.enqueue(on_success: 'CreateDatafilesInDataverseCallbackJob')
  end
end
