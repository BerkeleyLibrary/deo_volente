class UpdateDatafileAddMimetypeRemoveNotNullConstraints < ActiveRecord::Migration[7.1]
  def change
    change_column_null :datafiles, :filename, true
    change_column_null :datafiles, :realpath, true
    change_column_null :datafiles, :directoryLabel, true
    change_column_null :datafiles, :storageIdentifier, true
    change_column_null :datafiles, :md5Hash, true
    change_column_null :datafiles, :dataverseId, true
    change_column_null :datafiles, :description, true

    add_column :datafiles, :mimeType, :string
  end
end
