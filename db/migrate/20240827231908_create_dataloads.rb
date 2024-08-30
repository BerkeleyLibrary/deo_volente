class CreateDataloads < ActiveRecord::Migration[7.1]
  def change
    create_table :dataloads do |t|
      t.string :doi, null: false
      t.string :mountPoint, null: false
      t.string :directory, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
