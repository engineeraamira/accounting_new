class CreateDailyTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_transactions do |t|
      t.belongs_to :currency, null: true, foreign_key: true
      t.string :trans_id
      t.date :trans_date
      t.date :posted_date
      t.integer :created_by
      t.integer :posted_by
      t.text :description
      t.integer :status, default:1

      t.timestamps
    end
  end
end
