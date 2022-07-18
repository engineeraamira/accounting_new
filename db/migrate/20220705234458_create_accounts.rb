class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name_ar
      t.string :name_en
      t.string :account_number
      t.string :parent_account
      t.integer :final_account
      t.string :notes
      t.integer :account_type
      t.integer :account_nature
      t.float :credit
      t.float :debit
      t.float :balance

      t.timestamps
    end
  end
end
