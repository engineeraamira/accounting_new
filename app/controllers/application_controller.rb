class ApplicationController < ActionController::Base
  include Clearance::Controller
  before_action :require_login
    

    layout 'main'

end
