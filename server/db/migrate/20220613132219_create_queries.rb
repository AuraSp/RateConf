class CreateQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :queries, id: :string do |t|
      t.string :queryId
      t.string :rateConfData
      t.string :errorData
      t.string :awsS3name
      t.string :status
      t.string :enquirer
      t.timestamps
    end
  end
end
