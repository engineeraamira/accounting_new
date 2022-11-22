class CostCentersController < ApplicationController
  before_action :set_cost_center, only: %i[ show edit update destroy ]

  # GET /cost_centers or /cost_centers.json
  def index
    @cost_centers = CostCenter.all
    @cost_centers_arranged = CostCenter.arrange
    respond_to do |format|
      format.html { @cost_centers = CostCenter.all }
      format.json { render json: CostCenter.json_tree(@cost_centers_arranged)}
    end
  end

  def trial_balance
  end

  def get_datatable
    #sum all trans for all cost centers
    @cost_centers = CostCenter.order(:code).all   
    @hash = CostCenter.includes(:daily_transaction_details).group('cost_centers.id').pluck('cost_centers.id, SUM(daily_transaction_details.debit)', 'SUM(daily_transaction_details.credit)')
    
    #puts @hash
    
    @familiar_array = {}
    @get_cost_centers_data = @cost_centers.pluck(:id, :parent_center, :ancestry)
    #sum_children_transactions
    @cost_centers.each do |cost_center|
        if(cost_center.ancestry == nil)
            @childrenIds = @get_cost_centers_data.find_all { |el| ( (el[0] == cost_center.id) ||  ( (el[2] != nil) && ((el[2] == cost_center.id.to_s) ||  el[2].start_with?(cost_center.id.to_s + "/") ))) } # a.select will do the same
        else
            @childrenIds = @get_cost_centers_data.find_all { |el| (  (el[0] == cost_center.id) || ( (el[2] != nil) && ((el[2] == cost_center.id.to_s) ||  el[2].start_with?(cost_center.ancestry.to_s + "/"  + cost_center.id.to_s)))) } # a.select will do the same
        end
        @familiar_array[cost_center.id] = [0.00,0.00]

        @childrenIds.each do |child|
            @child_id = child[0]
            $total_trans = @hash.detect{ |(n, _, _)| ((n == @child_id)) }
            @familiar_array[cost_center.id][0] += ($total_trans[1] == nil)? 0.00 : $total_trans[1]   
            @familiar_array[cost_center.id][1] += ($total_trans[2] == nil)? 0.00 : $total_trans[2]  
        end
        puts @familiar_array
    end

    if(!(params[:search].empty?))
        puts params[:search][:value]
        @search_text = params[:search][:value]
        @cost_centers = @cost_centers.where("name_ar LIKE ? OR name_en LIKE ? OR code LIKE ?", "%#{@search_text}%", "%#{@search_text}%" , "%#{@search_text}%")
    end

    if(!(params[:cost_center_id].nil?))
        @cost_centers = @cost_centers.where(id: params[:cost_center_id])
    end

    if(!(params[:level].empty?))
        @cost_centers = @cost_centers.before_depth(params[:level].to_i)
    end

    if(params[:main_accounts] == "false")           #display last node in each branch
        @cost_centers = @cost_centers.includes(:cost_centers).where(cost_centers_count: 0)
    end

    @results = {}
    @count_records = @cost_centers.count
    @results["draw"] = params[:draw].to_i
    @results["recordsTotal"] = @count_records
    @results["recordsFiltered"] = @count_records
    @Length = (params[:length].to_i < 0)? @count_records : params[:length].to_i 
    @start = params[:start].to_i

    @cost_centers = @cost_centers.limit(@Length).offset(@start )
    @results["data"] = @cost_centers.map do |cost_center|
                            @debit = @familiar_array[cost_center.id][0]
            @credit = @familiar_array[cost_center.id][1]
            @difference = @debit - @credit
                            @balance_debit = (@difference > 0)?  @difference : 0
                            @balance_credit = (@difference < 0)?  @difference.abs : 0
                            @item = {"accountNumber" => cost_center.code, "nameAr" => cost_center.name_ar, "debit" => 0.00, "credit" => 0.00, "total_debit" => @debit, "total_credit" => @credit,"debit_balance" => @balance_debit, "credit_balance" => @balance_credit}
                            @item
                        end
    respond_to do |format|
      format.html
      format.json { render json: @results}
    end
  end

  # GET /cost_centers/1 or /cost_centers/1.json
  def show
  end

  # GET /cost_centers/new
  def new
    @cost_center = CostCenter.new
  end

  # GET /cost_centers/1/edit
  def edit
  end

  # POST /cost_centers or /cost_centers.json
  def create
    params[:cost_center][:parent_center] = params[:cost_center][:ancestry]
    if(params[:cost_center][:ancestry] != nil && params[:cost_center][:ancestry]) != ''
      @parent = CostCenter.find_by_id(params[:cost_center][:ancestry])
      @grand_parent = @parent.ancestry
      if @grand_parent == nil
        params[:cost_center][:ancestry] = params[:cost_center][:ancestry]
      else
        params[:cost_center][:ancestry] = @grand_parent.to_s + "/" + params[:cost_center][:ancestry].to_s
      end
    end
    @cost_center = CostCenter.new(cost_center_params)
    if @cost_center.save
      render json: {"Success": true, result: t('saved_successfully')}
    else
      render json: {"Errors": true, result: @cost_center.errors}
    end 


  end

  # PATCH/PUT /cost_centers/1 or /cost_centers/1.json
  def update
    respond_to do |format|
      if @cost_center.update(cost_center_params)
        format.html { redirect_to cost_center_url(@cost_center), notice: "Cost center was successfully updated." }
        format.json { render :show, status: :ok, location: @cost_center }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_centers/1 or /cost_centers/1.json
  def destroy
    @cost_center.destroy

    respond_to do |format|
      format.html { redirect_to cost_centers_url, notice: "Cost center was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_center
      @cost_center = CostCenter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cost_center_params
      params.require(:cost_center).permit(:name_en, :name_ar, :parent_center, :status, :deleted, :deleted_by, :deleted_date, :created_by, :code, :ancestry, :ancestry_depth)
    end
end
