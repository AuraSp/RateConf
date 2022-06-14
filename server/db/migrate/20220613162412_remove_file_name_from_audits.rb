class RemoveFileNameFromAudits < ActiveRecord::Migration[7.0]
  def change
    remove_column :audits, :File_name, :string
  end
end
