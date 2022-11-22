class Account < ApplicationRecord

    has_ancestry cache_depth: true
    #has_ancestry ancestry_column: :parent_account ## if you've used a different column name

    has_many :daily_transaction_details

    # to avoid n+1 problem
    has_many :accounts, foreign_key: :parent_account 

    #counter_cache option can be used to make finding the number of belonging objects more efficient. Consider these models
    belongs_to :account, counter_cache: true, foreign_key: :parent_account, optional: true

    #belongs_to :account, foreign_key: :parent_account, optional: true

    validates_presence_of :name_ar

    require 'roo'
    attr_accessor :file



    before_validation do
        self.ancestry = nil if self.ancestry.blank?
        self.parent_account = nil if self.parent_account.blank?
    end

    def self.json_tree(nodes)
        nodes.map do |node, sub_nodes|
          {:text => node.name_ar, :id => node.id, :children => Account.json_tree(sub_nodes).compact}
        end
    end

    def self.import(file)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
        #   row = Hash[[header, spreadsheet.row(i)].transpose]
        #   puts row
          
          arr = []
          arr << spreadsheet.row(i)
          arr.each_with_index do |item, index|
            account = find_by_account_number(item[1]) || new
            parent = nil
            ancestry = nil
            @parent = Account.where(name_ar: item[2]).first
            if @parent != nil
                parent = @parent.id
                @grand_parent = @parent.ancestry
                if @grand_parent == nil
                    ancestry = @parent.id
                else
                    ancestry = @grand_parent.to_s + "/" + @parent.id.to_s
                end
            end
            account.name_ar = item[0]
            account.account_number = item[1]
            account.parent_account = parent
            account.ancestry_depth = item[3]
            account.ancestry = ancestry
            #account.accounts_count = item[4]
            account.notes = item[5]
            account.save!
            #puts account
            #puts item[1]
          end
        #   product = find_by_id(row["id"]) || new
        #   product.attributes = row.to_hash.slice(*accessible_attributes)
        #   product.save!
        end
    end
      
    def self.open_spreadsheet(file)
        case File.extname(file.original_filename)
        when ".csv" then Csv.new(file.path, nil, :ignore)
        when ".xls" then Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path)
        else raise "Unknown file type: #{file.original_filename}"
        end
    end
    
end
