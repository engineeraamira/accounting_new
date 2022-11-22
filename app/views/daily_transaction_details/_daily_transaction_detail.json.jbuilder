json.extract! daily_transaction_detail, :id, :daily_transaction_id, :account_id, :cost_center_id, :currency_id, :description, :debit, :credit, :item_date, :created_at, :updated_at
json.url daily_transaction_detail_url(daily_transaction_detail, format: :json)
