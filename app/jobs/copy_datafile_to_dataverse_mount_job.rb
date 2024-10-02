# frozen_string_literal: true

# job to copy files from source directory to Dataverse files mount
class CopyDatafileToDataverseMountJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default

  def perform(datafile:)
    dest_fn = "#{dest_path}/#{datafile.filename}"
    FileUtils.mkdir_p(dest_path)
    FileUtils.cp(datafile.origFilename, dest_fn)
    dest_md5 = Digest::MD5.file(dest_fn).hexdigest
    return unless datafile.md5Hash != dest_md5

    datafile.update!(status: :failed)
    raise StandardError,
          "Destination #{dest_fn} (#{dest_md5} does not match source #{datafile.origFilename} #{datafile.md5Hash}"
  end

  def dest_path(datafile:)
    bare_doi = batch.properties[:dataload].doi.sub(/^doi:/, '')
    "#{DataverseService::Mountpoints.new.destination}/#{bare_doi}/#{datafile.directoryLabel}"
  end
end
