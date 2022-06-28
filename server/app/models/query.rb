class Query < ApplicationRecord
  has_one :audit
  default_scope -> { order(created_at: :desc) }
  validates :query_id, presence: true
  validates_associated :audit
end
