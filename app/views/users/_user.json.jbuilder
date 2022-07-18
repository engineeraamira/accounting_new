json.extract! user, :id, :email, :user_name, :phone, :user_group_id, :locale, :country_id, :city_id, :status, :verified, :deleted, :locked, :unlock_token, :login_attempts, :failed_attempts, :created_at, :updated_at
json.url user_url(user, format: :json)
