class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits do |t|
      t.string :File_name
      t.string :File_id
      t.string :Process_status

      t.timestamps
    end
  end
end
