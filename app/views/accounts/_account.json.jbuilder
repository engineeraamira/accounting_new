json.extract! account, :id, :name_ar, :name_en, :account_number, :parent_account, :final_account, :notes, :account_type, :account_nature, :credit, :debit, :balance, :created_at, :updated_at
json.url account_url(account, format: :json)
