class AddcacheDepthtoacoounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :ancestry_depth, :integer, default: 0

    accounts = select_all("SELECT id FROM accounts")

  end
end
