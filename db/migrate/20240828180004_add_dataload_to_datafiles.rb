class AddDataloadToDatafiles < ActiveRecord::Migration[7.1]
  def change
    add_reference :datafiles, :dataload, null: false, foreign_key: true
  end
end
