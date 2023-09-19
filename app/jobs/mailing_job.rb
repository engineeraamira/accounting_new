class MailingJob 

    include SuckerPunch::Job

    # Email Provider Background Job
    def perform(params)
      UserMailer.send_email(params).deliver_later
    end
    

end