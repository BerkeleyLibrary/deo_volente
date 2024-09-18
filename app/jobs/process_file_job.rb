class ProcessFileJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default
  # @todo make sure you understand globalid
  def perform(step:, file:)
    case step
    when :a
      f = Datafile.new
      pn = Pathname.new(file)
      f.origFilename = pn.to_s
      # f.realpath = "whaT??"
      # need basedir context
      f.directoryLabel, f.filename = pn.relative_path_from(basedir).split
      f.directoryLabel = '' if f.directoryLabel.to_s == '.'
      f.md5Hash = Digest::MD5.file(pn).hexdigest
      f.mimeType = Marcel::MimeType.for pn, name: f.filename
      # f.storageIdentifier = ...
      f.save
      batch.add { ProcessFileJob.perform_later(step: :b, file: f) }
    when :b
      puts 'woo'
    end
  end
end
