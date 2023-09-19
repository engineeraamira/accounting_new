class HomeController < ApplicationController
    skip_before_action :require_login, only: [:index]
  
    # GET /home
    # GET /home.json
    def index
        render layout:false
    end

    def dashboard
    end

end