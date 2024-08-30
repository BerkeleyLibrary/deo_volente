class UpdateDataload < ActiveRecord::Migration[7.1]
  def change
    add_column :dataloads, :user_name, :string, null: false
    add_column :dataloads, :user_email, :string, null: false
  end
end
