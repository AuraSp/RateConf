class ContactMailer < ApplicationMailer
  def analyzedData(e)
    mail(to: Rails.application.credentials.config.dig(:aws, :admin_email), subject: "Analization status")
  end

  def analyzedData_null(e)
    @e = e.logs
    mail(to: Rails.application.credentials.config.dig(:aws, :admin_email), subject: "Analization=null")
  end
end
