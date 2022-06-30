class Audit < ApplicationRecord
  belongs_to :query
  has_many :logs, dependent: :destroy
end
