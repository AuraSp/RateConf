class Audit < ApplicationRecord
  # belongs_to :
  has_many :audit_logs
#  , dependent: :destroy
end
