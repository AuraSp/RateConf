class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits, id: :string do |t|
      t.string :process_status
      t.string :query_id
      t.references :logs, null: false, foreign_key: true

      t.timestamps

    end
  end
end
