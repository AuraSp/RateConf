class Query < ApplicationRecord
  has_one :audit
  validates :query_id, presence: true
  validates :query_id, uniqueness: true
end
