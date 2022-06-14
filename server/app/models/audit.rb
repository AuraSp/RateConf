class Audit < ApplicationRecord
  self.primary_key = "File_id"
  validates :File_id, :Process_status, presence: true
end
