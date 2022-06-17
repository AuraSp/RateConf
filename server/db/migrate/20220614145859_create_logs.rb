class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs, auto_increment: true do |t|
      t.string :text
      t.belongs_to :audit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
