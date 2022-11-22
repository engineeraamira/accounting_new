class DailyTransactionsController < ApplicationController
  before_action :set_daily_transaction, only: %i[ show edit update destroy ]

  # GET /daily_transactions or /daily_transactions.json
  def index
    respond_to do |format|
      format.html { 
        @daily_transactions = DailyTransaction.all
        @currencies = Currency.all
        @next_transaction_id = (DailyTransaction.last.present?)? DailyTransaction.last.id + 1 : 1
        @cost_centers = CostCenter.order('code').all
      }
      format.xlsx { @daily_transaction_details = DailyTransactionDetail.order(:id).includes(:daily_transaction).all }
    end
  end

  # GET /daily_transactions/1 or /daily_transactions/1.json
  def show
  end

  # GET /daily_transactions/new
  def new
    @daily_transaction = DailyTransaction.new
  end

  # GET /daily_transactions/1/edit
  def edit
  end

  # POST /daily_transactions or /daily_transactions.json
  def create
    begin 
      ActiveRecord::Base.transaction do
        @daily_transaction = DailyTransaction.find_by_id(params[:daily_transaction][:id])
        @new_transaction = false
        if(@daily_transaction == nil)
          @new_transaction = true
          @daily_transaction = DailyTransaction.new(daily_transaction_params)
        else
          @daily_transaction = DailyTransaction.find_by_id(params[:daily_transaction][:id])
        end
        @sum_debit = 0
        @sum_credit = 0
        @can_add = false
        30.times do |i|
          if params[:details]["account_id_" + i.to_s] != "" && params[:details]["account_id_" + i.to_s] != nil && (params[:details]["debit_" + i.to_s] != "" || params[:details]["credit_" + i.to_s] != "")
            @sum_debit += params[:details]["debit_" + i.to_s].to_f
            @sum_credit += params[:details]["credit_" + i.to_s].to_f
            @can_add = true
          end
        end
        if @can_add == true
          if @sum_debit == @sum_credit
            if ((@new_transaction == true  && @daily_transaction.save!)|| (@new_transaction == false && @daily_transaction.update!(daily_transaction_params)))
              30.times do |i|
                if params[:details]["account_id_" + i.to_s] != "" && params[:details]["account_id_" + i.to_s] != nil && (params[:details]["debit_" + i.to_s] != "" || params[:details]["credit_" + i.to_s] != "")
                  if params[:details]["debit_" + i.to_s] == ""
                    params[:details]["debit_" + i.to_s] = 0
                  end
                  if params[:details]["credit_" + i.to_s] == ""
                    params[:details]["credit_" + i.to_s] = 0
                  end
                  if(params[:details]["id_" + i.to_s]) == ""
                    @daily_transaction.daily_transaction_details.create!(account_id: params[:details]["account_id_" + i.to_s].to_i, debit: params[:details]["debit_" + i.to_s].to_f, credit: params[:details]["credit_" + i.to_s].to_f, cost_center_id: params[:details]["cost_center_id_" + i.to_s].to_f, currency_id: params[:details]["currency_id_" + i.to_s].to_i, item_date: params[:details]["item_date_" + i.to_s], description: params[:details]["description_" + i.to_s])
                  else
                    @daily_transaction.daily_transaction_details.where(id: params[:details]["id_" + i.to_s]).update!(account_id: params[:details]["account_id_" + i.to_s].to_i, debit: params[:details]["debit_" + i.to_s].to_f, credit: params[:details]["credit_" + i.to_s].to_f, cost_center_id: params[:details]["cost_center_id_" + i.to_s].to_f, currency_id: params[:details]["currency_id_" + i.to_s].to_i, item_date: params[:details]["item_date_" + i.to_s], description: params[:details]["description_" + i.to_s])
                  end
                end
              end        
            end
            @status = true
            @msg = "saved_successfully"
          else
            @status = false
            @msg = "debit_is_not_equal_to_credit"
          end
        else
          @status = false
          @msg = "you_must_enter_two_transactions_at_least"
        end
      end
      render json: {"status": @status, message: @msg}
    rescue => error
      render json: {"status": false, message: error.message}
    end
  end


  def search_accounts
    @search_value = params[:search]
    @results = {}
    @plot_html = ""
    #@Accounts = Account.where(:parent_id => Account.roots.pluck(:id)).all

    @Accounts = Account.where("name_ar LIKE ? OR name_en LIKE ? OR account_number LIKE ?", "%#{@search_value}%", "%#{@search_value}%", "%#{@search_value}%").all.includes(:accounts)
		@Accounts.each do |value| 
      if value.accounts.empty?
			#@hasChildren = Account.where(parent_account: value.id).first
      #if (@hasChildren != nil && value.parent_account != nil)
      #@hasChildren = value.descendant_ids
			#if (@hasChildren.empty? )
        @plot_html += ' <div class="rounded d-flex flex-stack bg-active-lighten p-4" data-user-id="' + value.id.to_s + '">
                          <div class="d-flex align-items-center">
                              <label class="form-check form-check-custom form-check-solid me-5">
                                  <input class="form-check-input" type="radio" name="suggestion_accounts" data-kt-check="true" data-kt-check-target="[data-user-id=' + "'" + value.id.to_s  + "'" + ']" account-name="' + value.account_number + '-' + value.name_ar + '" value="' + value.id.to_s + '" />
                              </label>                            
                              <div class="ms-5">
                                  <a href="#" class="fs-5 fw-bolder text-gray-900 text-hover-primary mb-2">' + value.name_ar + '</a>
                                  <div class="fw-bold text-muted">' + value.account_number + '</div>
                              </div>
                          </div>                        
                        </div>
                        <div class="border-bottom border-gray-300 border-bottom-dashed"></div>'
        #@results[value.id] = [value.account_number, value.name_ar]
      end
    end
    render json: {"status": true, "result": @plot_html}
  end


  def transaction_details
    @current_trans_id = params[:current_trans_id]
    @type = params[:type]
    @transaction_details = {}
    @total_debit = 0
    @total_credit = 0
    if(@type == "previous")
      @transaction = DailyTransaction.where("id < ?", @current_trans_id).order('id DESC').first
    elsif(@type == "next")
      @transaction = DailyTransaction.where("id > ?", @current_trans_id).order('id DESC').first
    end
    if @transaction.nil?
      @status = false
    else
      @status = true
      @transaction_items = @transaction.daily_transaction_details
      @transaction_details["id"] = @transaction.id
      @transaction_details["trans_date"] = @transaction.trans_date
      @transaction_details["posted_date"] = @transaction.posted_date
      @transaction_details["description"] = @transaction.description
      @transaction_details["items"] = []
      @transaction_items.each_with_index do |item, index|
        @total_debit += item.debit
        @total_credit += item.credit
        @account_name = item.account.account_number.to_s + " - " + item.account.name_ar
        @transaction_details["items"] << [index+1, item.id, item.account_id, @account_name, item.currency_id, item.description, item.debit, item.credit, item.item_date, item.cost_center_id ]
      end
      @transaction_details["total_debit"] = @total_debit
      @transaction_details["total_credit"] = @total_credit
      @transaction_details["difference"] = @total_debit - @total_credit


    end
    
    render json: {"status": @status, "result": @transaction_details}

  end


  # PATCH/PUT /daily_transactions/1 or /daily_transactions/1.json
  def update
    respond_to do |format|
      if @daily_transaction.update(daily_transaction_params)
        format.html { redirect_to daily_transaction_url(@daily_transaction), notice: "Daily transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @daily_transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daily_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_transactions/1 or /daily_transactions/1.json
  def destroy
    @daily_transaction.destroy

    respond_to do |format|
      format.html { redirect_to daily_transactions_url, notice: "Daily transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_transaction
      @daily_transaction = DailyTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def daily_transaction_params
      params.require(:daily_transaction).permit(:currency_id, :trans_id, :trans_date, :posted_date, :created_by, :posted_by, :description, :status)
    end
end
