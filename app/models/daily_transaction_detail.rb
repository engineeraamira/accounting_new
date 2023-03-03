class DailyTransactionDetail < ApplicationRecord
  belongs_to :daily_transaction
  belongs_to :account
  belongs_to :cost_center, optional: true
  belongs_to :currency, optional: true

  before_create :default_currency
  before_save :default_values
  def default_values
    if self.cost_center_id == 0
      self.cost_center_id = nil
    end
    if self.currency_id == 0
      self.currency_id = nil
    end    
  end

  def default_currency
    self.default_currency = Setting.find_by_key('default_currency').value
    self.currency_rate = Currency.find_by_id(currency_id).rate
  end

end
