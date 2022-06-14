class CreateAuditLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_logs, id: :string do |t|
      t.string :text

      t.timestamps
    end
  end
end
