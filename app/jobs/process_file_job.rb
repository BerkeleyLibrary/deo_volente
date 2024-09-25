class ProcessFileJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches

  queue_as :default
  # @todo make sure you understand globalid
  def perform(step:, datafile:)
    case step
    when :a
      df = build_datafile(datafile)
      batch.add { ProcessFileJob.perform_later(step: :b, datafile: f) }
    when :b
      # set destination
      # copy file
      # compare md5
      puts 'woo'
    end
  end

  def build_datafile(fn)
    pn = Pathname.new(fn)
    f = Datafile.new(fn)
    f.origFilename = pn.to_s
    # f.realpath = "whaT??"
    # need basedir context
    f.directoryLabel, f.filename = pn.relative_path_from(basedir).split
    f.directoryLabel = '' if f.directoryLabel.to_s == '.'
    f.md5Hash = Digest::MD5.file(pn).hexdigest
    f.mimeType = Marcel::MimeType.for pn, name: f.filename
    # f.storageIdentifier = ...
    f.save
  end
end
