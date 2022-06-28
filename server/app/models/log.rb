class Log < ApplicationRecord
    belongs_to :audit
    validates :text, presence: true
end
