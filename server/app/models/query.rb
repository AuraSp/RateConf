class Query < ApplicationRecord
  has_one :audit
  default_scope -> { order(created_at: :desc) }
end
