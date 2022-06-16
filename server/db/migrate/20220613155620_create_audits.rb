class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits, auto_increment: true do |t|
      t.string :process_status
      t.belongs_to :query, null: false, foreign_key: true

      t.timestamps
    end
  end
end

