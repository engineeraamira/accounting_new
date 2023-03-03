class AddDefaultCurrencyToDailyTransDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_transaction_details, :default_currency, :integer, default: 1
    add_column :daily_transaction_details, :currency_rate, :float, default: 1
  end
end
