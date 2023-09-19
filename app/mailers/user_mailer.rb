class UserMailer < ApplicationMailer
    default from: "progress <no-reply@progresspioneers.com>"

    require 'sendgrid-ruby'
    include SendGrid

    # send a mail to users
    def send_email(params)
        @type = params[:type]
        @user = params[:user]
        @email = @user.email
        @subject = params[:subject]
        @params = params
        call_api(@email,@type,@subject,@params,"clearance_mailer")         
    end


    private
    def call_api(user_mail,type,subject,params,mailer) 
        begin
            @from = "progress <no-reply@progresspioneers.com>"

            ac = ActionController::Base.new()
            from = SendGrid::Email.new(name: "ProgressPioneers", email: @from)
            to = SendGrid::Email.new(email: user_mail)
            subject = subject
            html = ac.render_to_string("#{mailer}/#{type}", layout: false, locals:  { :params => params })
            content = Content.new(type: 'text/html', value: "#{html}")
            mail = SendGrid::Mail.new(from, subject, to, content)

            sg = SendGrid::API.new(api_key: "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")
            response = sg.client.mail._('send').post(request_body: mail.to_json)  
            puts response
        rescue =>e
          puts e.message.to_s
          #@log =  ErrorsLog.create(:user_id => 0,:message => e.message.to_s, :location => "email") 
        end
         
    end


   

      
end
