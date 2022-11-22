class AddAncestryToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :ancestry, :string
    add_index :accounts, :ancestry
  end
end
