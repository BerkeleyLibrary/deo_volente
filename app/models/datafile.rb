class Datafile < ApplicationRecord
  validates :origFilename,
        :filename,
        :realpath,
        :directoryLabel,
        :storageIdentifier,
        :md5Hash,
        :dataverseId,
        :description,
        presence: true

  enum status: { created: 0, in_progress: 1, completed: 2, failed: 3, archived: 4 }
end
