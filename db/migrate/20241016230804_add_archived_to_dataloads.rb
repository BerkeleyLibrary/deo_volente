class AddArchivedToDataloads < ActiveRecord::Migration[7.1]
  def change
    add_column :dataloads, :archived, :boolean, default: false
  end
end
