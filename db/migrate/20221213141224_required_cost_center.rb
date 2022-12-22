class RequiredCostCenter < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :required_cost_center, :boolean, default: false
  end
end
