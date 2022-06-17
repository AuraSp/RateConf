class ContactMailer < ApplicationMailer
  def authorization_successful()
    mail(to: Rails.application.credentials.dig(:aws, :admin_email), subject: "Access Granted")
  end

  # def pdf_null()
  #   mail(to: Rails.application.credentials.config.dig(:aws, :admin_email), subject: "Pdf=null")
  # end

  # def pdfInDB_null(error_message)
  #   @error_message = error_message

  #   mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "PdfInDB=-1")
  # end

  def analyzedData()
    mail(to: Rails.application.credentials.config.dig(:aws, :admin_email), subject: "Analization status")
  end

  def analyzedData_null()
    mail(to: Rails.application.credentials.config.dig(:aws, :admin_email), subject: "Analization=null")
  end
end
