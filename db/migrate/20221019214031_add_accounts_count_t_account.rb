class AddAccountsCountTAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :accounts_count, :integer, default: 0
  end
end
