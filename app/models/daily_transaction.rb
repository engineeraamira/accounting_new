class DailyTransaction < ApplicationRecord
  belongs_to :currency, optional: true
  has_many :daily_transaction_details

  require 'roo'
  attr_accessor :file


  def self.validate_transaction_details(params, general_currency)
    @results = {}
    @accounts_require_cost_center = Account.where(required_cost_center: true).all.ids

    @currencies_total = {}
    @can_add = false
    @status = true
    @message = ""
    @required_cost_centers = ""
    30.times do |i|
      if params[:details]["account_id_" + i.to_s] != "" && params[:details]["account_id_" + i.to_s] != nil && (params[:details]["debit_" + i.to_s] != "" || params[:details]["credit_" + i.to_s] != "")
        if (params[:details]["currency_id_" + i.to_s] != "")
          @currency = params[:details]["currency_id_" + i.to_s]
        else 
          if params[:daily_transaction][:currency_id] != nil
            @currency = params[:daily_transaction][:currency_id]
          else
            @currency = general_currency
          end
        end
        if @currencies_total[@currency] == nil
          @currencies_total[@currency] = params[:details]["debit_" + i.to_s].to_f - params[:details]["credit_" + i.to_s].to_f
        else
          @currencies_total[@currency] += params[:details]["debit_" + i.to_s].to_f - params[:details]["credit_" + i.to_s].to_f
        end
        if ((@accounts_require_cost_center.include? params[:details]["account_id_" + i.to_s].to_i) && (params[:details]["cost_center_id_" + i.to_s].empty? == true))
          @required_cost_centers += i.to_s + ", "
        end
        @can_add = true
      end
    end

    if @can_add == false
      @message += "you_must_enter_two_transactions_at_least, "
      @status = false
    end
    if @required_cost_centers != ""
      @message += "cost_center_is_required_for_the_following_rows :" + "  " + @required_cost_centers.to_s + " , "
      @status = false
    end
    @non_zero_diff_accounts = @currencies_total.select {|k, v| v != 0}
    if @non_zero_diff_accounts.keys.count != 0
      @message += "currency_debit_is_not_equal_to_currency_credit, "
      @status = false
    end

    if @message == ""
      @message = "saved_successfully"
    end

    @results["status"] = @status
    @results["message"] = @message
    puts @results
    return @results

  end


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      arr = []
      arr << spreadsheet.row(i)
      arr.each_with_index do |item, index|
        transaction = find_by_trans_id(item[0]) || new
        account = Account.find_by_name_ar(item[3])
        
        if item[7] != ''
          currency = Currency.find_by_name_ar(item[7]) || new
          if currency.new_record?
            currency.name_ar = item[7]
            currency.name_en = item[7]
            currency.save
          end
        end

        if item[8] != ''
          cost_center = CostCenter.find_by_name_ar(item[8]) || new
          if cost_center.new_record?
            cost_center.name_ar = item[8]
            cost_center.name_en = item[8]
            cost_center.save
          end
        end

        if account        

          @next_transaction_id = (DailyTransaction.last.present?)? DailyTransaction.last.trans_id.to_i + 1 : 1

          transaction.trans_id = (transaction.new_record?)? @next_transaction_id : transaction.trans_id

          transaction.trans_date = item[1]
          transaction.posted_date = item[1]
          transaction.description = item[2]
          
          if transaction.save!
            details = transaction.daily_transaction_details.where(account_id: account.id).first || DailyTransactionDetail.new
            details.daily_transaction_id = transaction.id
            details.account_id = account.id
            details.item_date = item[9]
            details.description = item[4]
            details.debit = (item[5] != '')? item[5] : 0.00
            details.credit = (item[6] != '')? item[6] : 0.00
            details.currency_id = (currency)? currency.id : nil
            details.cost_center_id = (cost_center)? cost_center.id : nil
            details.save!
          end
        end
      end
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
