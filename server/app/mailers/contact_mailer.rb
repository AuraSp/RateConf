class ContactMailer < ApplicationMailer
  def authorization_succesfull()
    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "Access Granted")
    Rails.logger.info 'Someone tried to access API'
  end

  def pdf_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "Pdf=null")
    Rails.logger.info 'Someone tried to access API'
  end

  def pdfInDB_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "PdfInDB=-1")
  end

  def analyzedData_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "AnalyzedData=null")
  end
end
