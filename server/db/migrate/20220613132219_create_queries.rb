class CreateQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :queries, auto_increment: true do |t|
      t.string :query_id
      t.string :rate_conf_data
      t.string :error_data
      t.string :aws_s3_name
      t.string :status
      t.string :enquirer
      t.timestamps
    end
  end
end
