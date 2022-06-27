class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  validates :name, presence: true
  validates :name, uniqueness: true
end
