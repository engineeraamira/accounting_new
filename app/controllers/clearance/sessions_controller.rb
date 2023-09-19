class Clearance::SessionsController < Clearance::BaseController
  before_action :redirect_signed_in_users, only: [:new]
  skip_before_action :require_login, only: [:create, :new, :destroy], raise: false

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        @status = true
        @msg = "signed_in successfully"
        #redirect_back_or url_after_create
      else
        @status = false
        @msg =  status.failure_message
        #flash.now.alert = status.failure_message
        #render template: "sessions/new", status: :unauthorized
      end
      render json: {"status": @status, msg: @msg}
    end
  end

  def destroy
    sign_out
    redirect_to url_after_destroy, status: :see_other
  end

  def new
    render template: "sessions/new", layout: false
  end

  private

  def redirect_signed_in_users
    if signed_in?
      redirect_to url_for_signed_in_users
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def url_after_destroy
    sign_in_url
  end

  def url_for_signed_in_users
    url_after_create
  end
end
