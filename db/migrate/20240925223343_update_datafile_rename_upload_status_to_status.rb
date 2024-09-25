class UpdateDatafileRenameUploadStatusToStatus < ActiveRecord::Migration[7.1]
  change_table :datafiles do |t|
    t.rename :uploadStatus, :status
  end
end
