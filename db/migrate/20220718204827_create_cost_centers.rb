class CreateCostCenters < ActiveRecord::Migration[7.0]
  def change
    create_table :cost_centers do |t|
      t.string :name_en
      t.string :name_ar
      t.integer :parent_center
      t.boolean :status, default: true
      t.integer :created_by

      t.timestamps
      t.boolean :deleted, default: false
      t.integer :deleted_by
      t.datetime :deleted_date
    end
  end
end
