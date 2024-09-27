# frozen_string_literal: true

# Service object to help construct Datafiles
class DatafileBuilder
  def initialize(orig_filename:, dataload:)
    @origFilename = orig_filename
    @dataload = dataload
    pathname = Pathname.new(@origFilename)
    @filename = pathname.basename.to_s
    @realpath = pathname.realpath
    dir_label = pathname.relative_path_from(dataload.basedir)[0]
    @directoryLabel = dir_label == '.' ? '' : dir_label
    @storageIdentifier = DataverseService::StorageIdentifier.new
    @md5Hash = Digest::MD5.file(@realpath).hexdigest
    @mimeType = Marcel::MimeType.for @realpath, name: @filename
  end

  def call(*)
    new(*).build_datafile
  end

  private

  def build_datafile
    @dataload.create_datafile!(origFilename: @origFilename,
                               filename: @filename, realpath: @realpath,
                               directoryLabel: @directoryLabel,
                               storageIdentifier: @storageIdentifier.to_s,
                               md5Hash: @md5Hash, mimeType: @mimeType,
                               description: '')
  end
end
