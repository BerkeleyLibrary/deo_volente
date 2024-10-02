# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class EnumerateFilesJob < ApplicationJob
  queue_as :default

  def perform(dataload:)
    dataload.update!(status: :in_progress)
    batch = GoodJob::Batch.new
    batch.properties[:dataload] = dataload
    batch.properties[:source_path] = DataverseService::Mountpoints.new.public_send("#{dataload.mountPoint}_path")

    batch.enqueue do
      Pathname.new(batch.properties[:source_path]).glob('**/*') do |f|
        PrepareDatafileObjectJob.perform_later(orig_filename: f.to_s)
      end
    end
  end
end
