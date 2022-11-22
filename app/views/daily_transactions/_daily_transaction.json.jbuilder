json.extract! daily_transaction, :id, :currency_id, :trans_id, :trans_date, :posted_date, :created_by, :posted_by, :description, :status, :created_at, :updated_at
json.url daily_transaction_url(daily_transaction, format: :json)
