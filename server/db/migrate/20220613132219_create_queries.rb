class CreateQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :queries do |t|
      t.string :queryId
      t.string :rateConfData
      t.string :errorData
      t.string :awsS3name
      t.string :status
      t.string :enquirer
      self.primary_key = "queryId"
      t.timestamps
    end
  end
end
