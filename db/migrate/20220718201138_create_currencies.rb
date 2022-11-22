class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :name_en
      t.string :name_ar
      t.string :code
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
