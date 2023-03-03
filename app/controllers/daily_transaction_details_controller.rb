class DailyTransactionDetailsController < ApplicationController
  before_action :set_daily_transaction_detail, only: %i[ show edit update destroy ]

  # GET /daily_transaction_details or /daily_transaction_details.json
  def index
    @daily_transaction_details = DailyTransactionDetail.all
  end

  # GET /daily_transaction_details/1 or /daily_transaction_details/1.json
  def show
  end

  # GET /daily_transaction_details/new
  def new
    @daily_transaction_detail = DailyTransactionDetail.new
  end

  # GET /daily_transaction_details/1/edit
  def edit
  end

  # POST /daily_transaction_details or /daily_transaction_details.json
  def create
    @daily_transaction_detail = DailyTransactionDetail.new(daily_transaction_detail_params)

    respond_to do |format|
      if @daily_transaction_detail.save
        format.html { redirect_to daily_transaction_detail_url(@daily_transaction_detail), notice: "Daily transaction detail was successfully created." }
        format.json { render :show, status: :created, location: @daily_transaction_detail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @daily_transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_transaction_details/1 or /daily_transaction_details/1.json
  def update
    respond_to do |format|
      if @daily_transaction_detail.update(daily_transaction_detail_params)
        format.html { redirect_to daily_transaction_detail_url(@daily_transaction_detail), notice: "Daily transaction detail was successfully updated." }
        format.json { render :show, status: :ok, location: @daily_transaction_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daily_transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_transaction_details/1 or /daily_transaction_details/1.json
  def destroy
    @daily_transaction_detail.destroy

    respond_to do |format|
      format.html { redirect_to daily_transaction_details_url, notice: "Daily transaction detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_transaction_detail
      @daily_transaction_detail = DailyTransactionDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def daily_transaction_detail_params
      params.require(:daily_transaction_detail).permit(:daily_transaction_id, :account_id, :cost_center_id, :currency_id, :description, :debit, :credit, :item_date, :currency_rate)
    end
end
