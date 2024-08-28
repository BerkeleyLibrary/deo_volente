class CreateDatafiles < ActiveRecord::Migration[7.1]
  def change
    create_table :datafiles do |t|
      t.string :origFilename
      t.string :filename
      t.string :realpath
      t.string :directoryLabel
      t.string :storageIdentifier
      t.string :md5Hash
      t.string :dataverseId
      t.string :description
      t.integer :uploadStatus, null: false, default: 0

      t.timestamps
    end
  end
end
