class CreateDailyTransactionDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_transaction_details do |t|
      t.belongs_to :daily_transaction, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :cost_center, null: true, foreign_key: true, default: nil
      t.belongs_to :currency, null: true, foreign_key: true, default: nil
      t.text :description
      t.float :debit, default: 0
      t.float :credit, default: 0
      t.date :item_date

      t.timestamps
    end
  end
end
