class ChangeProcessStatusToBeBooleanInAudit < ActiveRecord::Migration[7.0]
  def change
    change_column :audits, :Process_status, :boolean
  end
end
