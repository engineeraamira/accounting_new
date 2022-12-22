class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts or /accounts.json
  def index
    respond_to do |format|
        format.html { @accounts = Account.all }
        format.xlsx { @accounts = Account.order(:account_number).includes(:account).all }
    end
  end

  def import
    Account.import(params[:file])
    redirect_to accounts_path, notice: "تم استيراد الحسابات بنجاح"
  end

  def trial_balance
  end

  def accounts_tree

    # $parent = $_REQUEST["parent"];
    # $data = array();
    # $states = array(
    #   "success",
    #   "info",
    #   "danger",
    #   "warning"
    # );
    # if ($parent == "#") {
    # for($i = 1; $i < rand(4, 7); $i++) {
    #   $data[] = array(
    #   "id" => "node_" . time() . rand(1, 100000),
    #   "text" => "Node #" . $i,
    #   "icon" => "fa fa-folder icon-lg kt-font-" . ($states[rand(0, 3)]),
    #   "children" => true,
    #   "type" => "root"
    #   );
    # }
    # } else {
    #   if (rand(1, 5) === 3) {
    #     $data[] = array(
    #     "id" => "node_" . time() . rand(1, 100000),
    #     "icon" => "fa fa-file fa-large kt-font-default",
    #     "text" => "No children ",
    #     "state" => array("disabled" => true),
    #     "children" => false
    #     );
    #   } else {
    #     for($i = 1; $i < rand(2, 4); $i++) {
    #       $data[] = array(
    #         "id" => "node_" . time() . rand(1, 100000),
    #         "icon" => ( rand(0, 3) == 2 ? "fa fa-file icon-lg" : "fa fa-folder icon-lg")." kt-font-" . ($states[rand(0, 3)]),
    #         "text" => "Node " . time(),
    #         "children" => ( rand(0, 3) == 2 ? false : true)
    #       );
    #     }
    #   }
    # }
    # header('Content-type: text/json');
    # header('Content-type: application/json');
    # header('Access-Control-Allow-Origin: *');
    # echo json_encode($data);

    @tree = [
              {"id":"node_165715391677456","icon":"fa fa-file fa-large kt-font-default","text":"رئيسى","state":{"disabled":true},"children":[{"id":"node_16571539167745","icon":"fa fa-file fa-large kt-font-default","text":"اول","state":{"disabled":false}, "children":true}]},
            ]

    @accounts = Account.arrange
    render json: Account.json_tree(@accounts)  #@tree
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    params[:account][:parent_account] = params[:account][:ancestry]
    if(params[:account][:ancestry] != nil && params[:account][:ancestry]) != ''
      @parent = Account.find_by_id(params[:account][:ancestry])
      @grand_parent = @parent.ancestry
      if @grand_parent == nil
        params[:account][:ancestry] = params[:account][:ancestry]
      else
        params[:account][:ancestry] = @grand_parent.to_s + "/" + params[:account][:ancestry].to_s
      end
    end
    @account = Account.new(account_params)
    if @account.save
      render json: {"Success": true, result: t('saved_successfully')}
    else
      render json: {"Errors": true, result: @account.errors}
    end 
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name_ar, :name_en, :account_number, :parent_account, :ancestry, :ancestry_depth, :final_account, :notes, :account_type, :account_nature, :credit, :debit, :balance, :required_cost_center)
    end
end
