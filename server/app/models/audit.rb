class Audit < ApplicationRecord
  belongs_to :query
  has_many :logs
  validates_associated :logs
  #  , dependent: :destroy
end
