class CurrenciesController < ApplicationController
  before_action :set_currency, only: %i[ show edit update destroy ]

  # GET /currencies or /currencies.json
  def index
    @currencies = Currency.all
  end

  # GET /currencies/1 or /currencies/1.json
  def show
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
  end

  # POST /currencies or /currencies.json
  def create
    @currency = Currency.new(currency_params)
    if @currency.save
      render json: {"Success": true, result: t('saved_successfully')}
    else
      render json: {"Errors": true, result: @currency.errors}
    end 
  end

  # PATCH/PUT /currencies/1 or /currencies/1.json
  def update
    if @currency.update(currency_params)
      render json: {"Success": true, result: t('saved_successfully')}
    else
      render json: {"Errors": true, result: @currency.errors}
    end 
  end

  def draw_currencies
   
    @results = {}
    @Currencies = Currency.where(status: true)
    if(!(params[:search].empty?))
      @search_text = params[:search][:value]
      @Currencies = @Currencies.where("name_ar LIKE ? OR name_en LIKE ? OR code LIKE ? OR rate LIKE ?", "%#{@search_text}%", "%#{@search_text}%" , "%#{@search_text}%", "%#{@search_text}%")
    end
    @Currencies = @Currencies.all
    @count_records = @Currencies.count
    @results["draw"] = params[:draw].to_i
    @results["recordsTotal"] = @count_records
    @results["recordsFiltered"] = @count_records
    @Length = (params[:length].to_i < 0)? @count_records : params[:length].to_i 
    @start = params[:start].to_i

    @currencies = @Currencies.limit(@Length).offset(@start )
    @results["data"] = @currencies.map do |currency|
                            @actions = '<td class="text-end">
                                          <a class="btn btn-icon btn-active-light-primary w-30px h-30px me-3 edit_item" data-details=' + "'" + currency.to_json + "'" + ' data-bs-toggle="modal" data-bs-target="#kt_modal_add_permission">
                                            <span class="svg-icon svg-icon-3">
                                              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                                <path opacity="0.3" d="M21.4 8.35303L19.241 10.511L13.485 4.755L15.643 2.59595C16.0248 2.21423 16.5426 1.99988 17.0825 1.99988C17.6224 1.99988 18.1402 2.21423 18.522 2.59595L21.4 5.474C21.7817 5.85581 21.9962 6.37355 21.9962 6.91345C21.9962 7.45335 21.7817 7.97122 21.4 8.35303ZM3.68699 21.932L9.88699 19.865L4.13099 14.109L2.06399 20.309C1.98815 20.5354 1.97703 20.7787 2.03189 21.0111C2.08674 21.2436 2.2054 21.4561 2.37449 21.6248C2.54359 21.7934 2.75641 21.9115 2.989 21.9658C3.22158 22.0201 3.4647 22.0084 3.69099 21.932H3.68699Z" fill="black"></path>
                                                <path d="M5.574 21.3L3.692 21.928C3.46591 22.0032 3.22334 22.0141 2.99144 21.9594C2.75954 21.9046 2.54744 21.7864 2.3789 21.6179C2.21036 21.4495 2.09202 21.2375 2.03711 21.0056C1.9822 20.7737 1.99289 20.5312 2.06799 20.3051L2.696 18.422L5.574 21.3ZM4.13499 14.105L9.891 19.861L19.245 10.507L13.489 4.75098L4.13499 14.105Z" fill="black"></path>
                                              </svg>
                                            </span>
                                          </a>
                                          <button class="btn btn-icon btn-active-light-primary w-30px h-30px" data-kt-permissions-table-filter="delete_row">
                                            <span class="svg-icon svg-icon-3">
                                              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                                <path d="M5 9C5 8.44772 5.44772 8 6 8H18C18.5523 8 19 8.44772 19 9V18C19 19.6569 17.6569 21 16 21H8C6.34315 21 5 19.6569 5 18V9Z" fill="black" />
                                                <path opacity="0.5" d="M5 5C5 4.44772 5.44772 4 6 4H18C18.5523 4 19 4.44772 19 5V5C19 5.55228 18.5523 6 18 6H6C5.44772 6 5 5.55228 5 5V5Z" fill="black" />
                                                <path opacity="0.5" d="M9 4C9 3.44772 9.44772 3 10 3H14C14.5523 3 15 3.44772 15 4V4H9V4Z" fill="black" />
                                              </svg>
                                            </span>
                                          </button>
                                        </td>'
                            @item = {"id" => currency.id, "currencyCode" => currency.code, "name" => currency.name_ar, "rate" => currency.rate, "nameAr" => currency.created_at, "updatedDate" => currency.updated_at, "actions" => @actions}
                            @item
                        end
    respond_to do |format|
      format.html
      format.json { render json: @results}
    end
end

  # DELETE /currencies/1 or /currencies/1.json
  def destroy
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to currencies_url, notice: "Currency was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def currency_params
      params.require(:currency).permit(:name_en, :name_ar, :code, :status, :rate)
    end
end
