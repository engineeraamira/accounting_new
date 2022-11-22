class AddCostCentersTreeSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :cost_centers, :code
    add_index :cost_centers, :parent_center
    add_column :cost_centers, :ancestry_depth, :integer, default: 0
    add_column :cost_centers, :ancestry, :string
    add_index :cost_centers, :ancestry
    add_column :cost_centers, :cost_centers_count, :integer, default: 0
  end
end
