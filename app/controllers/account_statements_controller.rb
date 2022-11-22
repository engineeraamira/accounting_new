class AccountStatementsController < ApplicationController

    # GET /account_statements or /account_statements.json
    def index
        @daily_transaction_details = DailyTransactionDetail.all
    end
  
    def draw_account_statement
      @results = {}
      @daily_transaction_details = DailyTransactionDetail.order(:item_date).includes(:daily_transaction, :account).all
  
      @count_records = @daily_transaction_details.count
      @results["draw"] = params[:draw].to_i
      @results["recordsTotal"] = @count_records
      @results["recordsFiltered"] = @count_records
      @Length = (params[:length].to_i < 0)? @count_records : params[:length].to_i 
      @start = params[:start].to_i
  
      @total_balance = 0;
  
      @daily_transaction_details = @daily_transaction_details.limit(@Length).offset(@start )
      @total_debit = 0
      @total_credit = 0

      @content = []
      @content << {"TranNo" => "الرصيد السابق", "description" => '', "debit" => '', "credit" => '', "balance" => '', "date" => ''}
      @daily_transaction_details.map do |daily_transaction_data|
        @debit = daily_transaction_data.debit
        @credit = daily_transaction_data.credit
        @total_balance = @total_balance + @debit - @credit

        @total_debit += @debit
        @total_credit += @credit
                        
        @item = {"TranNo" => daily_transaction_data.daily_transaction.id, "description" => daily_transaction_data.description, "debit" => @debit, "credit" => @credit, "balance" => @total_balance, "date" => daily_transaction_data.item_date}
        @content << @item
      end

      @content << {"TranNo" => "", "description" => 'المجموع', "debit" => @total_debit, "credit" => @total_credit, "balance" => @total_balance, "date" => ''}

      @results["data"] = @content
      respond_to do |format|
        format.html
        format.json { render json: @results}
      end
    end

   
    
end