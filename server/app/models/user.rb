class User < ApplicationRecord
  has_many :api_keys, as: :bearer
end
