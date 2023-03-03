class SettingsController < ApplicationController
  before_action :set_setting, only: %i[ show edit update destroy ]

  # GET /settings or /settings.json
  def index
    @settings = Setting.all
    @default_language = @settings.find_by_key('default_language').value
    @default_currency = @settings.find_by_key('default_currency').value
    @company_logo = @settings.find_by_key('company_logo')
    @logo_url = (@company_logo.image.attached?)? url_for(@company_logo.image) : '/demo7/dist/assets/media/svg/files/blank-image.svg'
    @months = ["يناير","فبراير","مارس","أبريل","مايو","يونيو","يولية","أغسطس","سبتمبر","أكتوبر","نوفمبر","ديسمبر"]
    @currencies = Currency.all

  end

  # GET /settings/1 or /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings or /settings.json
  def create
    @settings = Setting.all
    @single_values = ["company_name","default_language","default_currency","mobile","email","fax"]
    @single_values.each do |single_value|
      @settings.where(key: single_value).update(value: params[single_value])
    end    
    @settings.where(key: "fiscal_year").update(value1_ar: params["fiscal_year_start"], value1_en: params["fiscal_year_end"])
    if(params["company_logo"].present?)
      @settings.find_by_key("company_logo").image.attach(params["company_logo"])
    end

    render json: {"Success": true, result: t('saved_successfully')}

  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to setting_url(@setting), notice: "Setting was successfully updated." }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1 or /settings/1.json
  def destroy
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to settings_url, notice: "Setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:key, :description, :value, :boolean_value, :value1_ar, :value1_en, :value2_ar, :value2_en, :text1_ar, :text1_en, :text2_ar, :text2_en)
    end
end
