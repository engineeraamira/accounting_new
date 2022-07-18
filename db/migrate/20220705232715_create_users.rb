class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :user_name
      t.string :phone
      t.integer :user_group_id, default: 2
      t.integer :locale, default: 1
      t.integer :country_id
      t.integer :city_id
      t.boolean :status, default: true
      t.boolean :verified, default: true
      t.boolean :deleted, default: false
      t.boolean :locked, default: false
      t.string :unlock_token
      t.integer :login_attempts, default: 0
      t.integer :failed_attempts, default: 0

      t.timestamps
    end
  end
end
