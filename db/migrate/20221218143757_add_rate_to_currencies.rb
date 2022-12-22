class AddRateToCurrencies < ActiveRecord::Migration[7.0]
  def change
    add_column :currencies, :rate, :float, default: 0
  end
end
