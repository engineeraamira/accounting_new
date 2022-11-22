class DailyTransaction < ApplicationRecord
  belongs_to :currency, optional: true
  has_many :daily_transaction_details
end
