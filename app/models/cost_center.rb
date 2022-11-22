class CostCenter < ApplicationRecord

    has_ancestry cache_depth: true

    # to avoid n+1 problem
    has_many :cost_centers, foreign_key: :parent_center

    has_many :daily_transaction_details


    #counter_cache option can be used to make finding the number of belonging objects more efficient. Consider these models
    belongs_to :cost_center, counter_cache: true, foreign_key: :parent_center, optional: true
    validates_presence_of :name_ar

    before_validation do
        self.ancestry = nil if self.ancestry.blank?
        self.parent_center = nil if self.parent_center.blank?
    end

    def self.json_tree(nodes)
        nodes.map do |node, sub_nodes|
          {:text => node.name_ar, :id => node.id, :children => CostCenter.json_tree(sub_nodes).compact}
        end
    end
end
