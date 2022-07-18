class Account < ApplicationRecord

    has_ancestry ancestry_column: :parent_account ## if you've used a different column name

    before_validation do
        self.parent_account = nil if self.parent_account.blank?
    end

    def self.json_tree(nodes)
        nodes.map do |node, sub_nodes|
          {:text => node.name_ar, :id => node.id, :children => Account.json_tree(sub_nodes).compact}
        end
    end
end
