class MakeQueryIdUnique < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:queries, :query_id, false )
  end
  add_index :queries, :query_id, unique: true
end
